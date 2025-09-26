{
  lib,
  autoPatchelfHook,
  bash,
  copyDesktopItems,
  coreutils,
  cryptsetup,
  dosfstools,
  e2fsprogs,
  exfat,
  fetchurl,
  gawk,
  gnugrep,
  gnused,
  gtk3,
  hexdump,
  makeDesktopItem,
  makeWrapper,
  ntfs3g,
  parted,
  procps,
  stdenv,
  util-linux,
  which,
  xfsprogs,
  xz,
  defaultGuiType ? "",
  withCryptsetup ? false,
  withXfs ? false,
  withExt4 ? false,
  withNtfs ? false,
  withGtk3 ? defaultGuiType == "gtk3",
  withQt5 ? defaultGuiType == "qt5",
  libsForQt5,
}:

assert lib.elem defaultGuiType [
  ""
  "gtk3"
  "qt5"
];
assert defaultGuiType == "gtk3" -> withGtk3;
assert defaultGuiType == "qt5" -> withQt5;

let
  inherit (lib) optionals optionalString;
  inherit (libsForQt5) qtbase wrapQtAppsHook;
  arch =
    {
      x86_64-linux = "x86_64";
      i686-linux = "i386";
      aarch64-linux = "aarch64";
      mipsel-linux = "mips64el";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation (finalAttrs: {
  pname =
    "ventoy"
    + optionalString (defaultGuiType == "gtk3") "-gtk3"
    + optionalString (defaultGuiType == "qt5") "-qt5";
  version = "1.1.07";

  src = fetchurl {
    url = "https://github.com/ventoy/Ventoy/releases/download/v${finalAttrs.version}/ventoy-${finalAttrs.version}-linux.tar.gz";
    hash = "sha256-T/q85GiwPWNXzl9FlOIJcU0VCdBl2hApOAltrWZUw24=";
  };

  patches = [
    ./000-nixos-sanitization.patch
  ];

  postPatch = ''
    # Fix permissions.
    find -type f -name \*.sh -exec chmod a+x '{}' \;

    # Fix path to log.
    sed -i 's:log\.txt:/var/log/ventoy\.log:g' \
        WebUI/static/js/languages.js tool/languages.json
  '';

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ]
  ++ optionals (withQt5 || withGtk3) [ copyDesktopItems ]
  ++ optionals withQt5 [ wrapQtAppsHook ];

  buildInputs = [
    bash
    coreutils
    dosfstools
    exfat
    gawk
    gnugrep
    gnused
    hexdump
    parted
    procps
    util-linux
    which
    xz
  ]
  ++ optionals withCryptsetup [ cryptsetup ]
  ++ optionals withExt4 [ e2fsprogs ]
  ++ optionals withGtk3 [ gtk3 ]
  ++ optionals withNtfs [ ntfs3g ]
  ++ optionals withXfs [ xfsprogs ]
  ++ optionals withQt5 [ qtbase ];

  strictDeps = true;

  desktopItems = [
    (makeDesktopItem {
      name = "Ventoy";
      desktopName = "Ventoy";
      comment = "Tool to create bootable USB drive for ISO/WIM/IMG/VHD(x)/EFI files";
      icon = "VentoyLogo";
      exec = "ventoy-gui";
      terminal = false;
      categories = [ "Utility" ];
      startupNotify = true;
    })
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    # Setup variables
    local VENTOY_PATH="$out"/share/ventoy
    local ARCH='${arch}'

    # Prepare
    cd tool/"$ARCH"
    rm ash* hexdump* mkexfatfs* mount.exfat-fuse* xzcat*
    for archive in *.xz; do
        xzcat "$archive" > "''${archive%.xz}"
        rm "$archive"
    done
    chmod a+x *
    cd -

    # Cleanup.
    case "$ARCH" in
        x86_64) rm -r {tool/,VentoyGUI.}{i386,aarch64,mips64el};;
        i386) rm -r {tool/,VentoyGUI.}{x86_64,aarch64,mips64el};;
        aarch64) rm -r {tool/,VentoyGUI.}{x86_64,i386,mips64el};;
        mips64el) rm -r {tool/,VentoyGUI.}{x86_64,i386,aarch64};;
    esac
    rm README
    rm tool/"$ARCH"/Ventoy2Disk.gtk2 || true  # For aarch64 and mips64el.

    # Copy from "$src" to "$out"
    mkdir -p "$out"/bin "$VENTOY_PATH"
    cp -r . "$VENTOY_PATH"

    # Fill bin dir
    for f in Ventoy2Disk.sh_ventoy VentoyWeb.sh_ventoy-web \
             CreatePersistentImg.sh_ventoy-persistent \
             ExtendPersistentImg.sh_ventoy-extend-persistent \
             VentoyPlugson.sh_ventoy-plugson; do
        local bin="''${f%_*}" wrapper="''${f#*_}"
        makeWrapper "$VENTOY_PATH/$bin" "$out/bin/$wrapper" \
                    --prefix PATH : "${lib.makeBinPath finalAttrs.buildInputs}" \
                    --chdir "$VENTOY_PATH"
    done
  ''
  # VentoGUI uses the `ventoy_gui_type` file to determine the type of GUI.
  # See: https://github.com/ventoy/Ventoy/blob/v1.0.78/LinuxGUI/Ventoy2Disk/ventoy_gui.c#L1096
  + optionalString (withGtk3 || withQt5) ''
    echo "${defaultGuiType}" > "$VENTOY_PATH/ventoy_gui_type"
    makeWrapper "$VENTOY_PATH/VentoyGUI.$ARCH" "$out/bin/ventoy-gui" \
                --prefix PATH : "${lib.makeBinPath finalAttrs.buildInputs}" \
                --chdir "$VENTOY_PATH"
    mkdir "$out"/share/{applications,pixmaps}
    ln -s "$VENTOY_PATH"/WebUI/static/img/VentoyLogo.png "$out"/share/pixmaps/
  ''
  + optionalString (!withGtk3) ''
    rm "$VENTOY_PATH"/tool/{"$ARCH"/Ventoy2Disk.gtk3,VentoyGTK.glade}
  ''
  + optionalString (!withQt5) ''
    rm "$VENTOY_PATH/tool/$ARCH/Ventoy2Disk.qt5"
  ''
  + optionalString (!withGtk3 && !withQt5) ''
    rm "$VENTOY_PATH"/VentoyGUI.*
  ''
  + ''

    runHook postInstall
  '';

  meta = {
    homepage = "https://www.ventoy.net";
    description =
      "New Bootable USB Solution" + optionalString (defaultGuiType != "") " with GUI support";
    longDescription = ''
      Ventoy is an open source tool to create bootable USB drive for
      ISO/WIM/IMG/VHD(x)/EFI files.  With ventoy, you don't need to format the
      disk over and over, you just need to copy the ISO/WIM/IMG/VHD(x)/EFI files
      to the USB drive and boot them directly. You can copy many files at a time
      and ventoy will give you a boot menu to select them. You can also browse
      ISO/WIM/IMG/VHD(x)/EFI files in local disk and boot them. x86 Legacy
      BIOS, IA32 UEFI, x86_64 UEFI, ARM64 UEFI and MIPS64EL UEFI are supported
      in the same way.  Most type of OS supported
      (Windows/WinPE/Linux/ChromeOS/Unix/VMware/Xen...).  With ventoy you can
      also browse ISO/WIM/IMG/VHD(x)/EFI files in local disk and boot them.
      800+ image files are tested.  90%+ distros in DistroWatch supported.
    '';
    changelog = "https://www.ventoy.net/doc_news.html";
    knownVulnerabilities = [
      ''
        Ventoy uses binary blobs which can't be trusted to be free of malware or compliant to their licenses.
        https://github.com/NixOS/nixpkgs/issues/404663
        See the following Issues for context:
        https://github.com/ventoy/Ventoy/issues/2795
        https://github.com/ventoy/Ventoy/issues/3224
      ''
    ];
    license = lib.licenses.unfree;
    mainProgram = "ventoy";
    maintainers = with lib.maintainers; [
      johnrtitor
    ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
      "aarch64-linux"
      "mipsel-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
