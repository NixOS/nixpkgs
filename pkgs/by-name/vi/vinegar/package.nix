{
  lib,
  buildGoModule,
  wine64Packages,
  fetchFromGitHub,
  glib,
  makeBinaryWrapper,
  pkg-config,
  cairo,
  gdk-pixbuf,
  graphene,
  gtk4,
  libadwaita,
  libGL,
  libxkbcommon,
  pango,
  vulkan-headers,
  vulkan-loader,
  wayland,
  winetricks,
  libxfixes,
  libxcursor,
  libx11,
  symlinkJoin,
  nix-update-script,
  gettext,
}:
let
  # Based on wine 11.21
  kombuchaPatches = fetchFromGitHub {
    name = "kombucha";
    owner = "vinegarhq";
    repo = "kombucha";
    tag = "20261112181801";
    hash = "sha256-9EOE+mTvoeykfN2v/A4jlcxXTU9irI2TDEbyE6r8HP4=";
    meta.license = lib.licenses.lgpl21Only;
  };

  wine =
    (wine64Packages.unstable.override {
      dbusSupport = true;
      embedInstallers = true;
      pulseaudioSupport = true;
      x11Support = true;
      waylandSupport = true;
      alsaSupport = false;
    }).overrideAttrs
      (oldAttrs: {
        # https://github.com/vinegarhq/kombucha/blob/20261112181801/.github/workflows/build.yml
        configureFlags =
          lib.remove "--enable-win64" (oldAttrs.configureFlags or [ ])
          ++ import ./kombucha-configure-flags.nix;
        patches =
          oldAttrs.patches or [ ]
          ++ map (name: "${kombuchaPatches}/patches/${name}") [
            "0001-win32u-Apply-work-area-changes-to-virtual-desktop-mo.patch"
            "0002-explorer-Account-for-the-actual-size-of-the-taskbar-.patch"
            "0003-explorer-Update-system-work-area-rect-to-exclude-tas.patch"
            "0004-winex11.drv-Move-Xfixes-extension-query-to-process_a.patch"
            "0005-winex11-Use-XFixes-to-hide-cursor-before-warping-it.patch"
            "0006-explorer-Enable-virtual-desktop-shell-by-default.patch"
            "0007-ntdll-Add-kombucha_hacks.patch"
            "0008-ntdll-HACK-Search-for-ucrtbase-using-common-rules.patch"
            "0009-ntdll-Keep-more-LFH-block-groups-alive.patch"
            "0010-ntdll-Use-default-loadorder-for-DXVK-DLLs.patch"
            "0011-server-wineboot-Remove-syswow64-support-and-unnecess.patch"
            "0012-win32u-Don-t-load-bitmap-only-TTF-fonts-without-bitm.patch"
            "0013-wine.inf-Add-KombuchaOverrides.patch"
            "0014-wineboot-Add-WINEBOOT_HIDE_DIALOG-environment-variab.patch"
            "0015-winex11-Raise-hidden-windows-above-siblings-in-virtu.patch"
            "0016-winex11.drv-Use-the-Win32-move-loop-under-Xwayland.patch"
            "0017-winex11.drv-Don-t-let-the-WM-override-a-withdrawn-de.patch"
          ];
      });
in
buildGoModule (finalAttrs: {
  pname = "vinegar";
  version = "1.9.4";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "vinegarhq";
    repo = "vinegar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5RwRiHVOYxMBL92Z8H+0VxJtz6Y7yXpv70UqesLINCk=";
  };

  vendorHash = "sha256-kS8awIGI5xHY4i7hvKMLcZKdMiFaoirokd3TSpMbC8c=";

  nativeBuildInputs = [
    glib
    makeBinaryWrapper
    pkg-config
    gettext
  ];

  buildInputs = [
    cairo
    gdk-pixbuf
    glib.out
    graphene
    gtk4
    libadwaita
    libGL
    libxkbcommon
    pango.out
    vulkan-headers
    vulkan-loader
    wayland
    wine
    winetricks
    libx11
    libxcursor
    libxfixes
  ];

  postPatch = ''
    substituteInPlace Makefile --replace-fail 'gtk-update-icon-cache' '${lib.getExe' gtk4 "gtk4-update-icon-cache"}'
    substituteInPlace internal/config/config.go \
      --replace-fail 'cfg.Studio.WineRoot = dirs.WinePath' 'cfg.Studio.WineRoot = "${wine}"'
  '';

  buildPhase = ''
    runHook preBuild

    make PREFIX=$out

    runHook postBuild
  '';

  # Add getGoDirs to checkPhase since it is not being provided by the buildPhase
  preCheck = ''
    getGoDirs() {
      local type;
      type="$1"
      if [ -n "$subPackages" ]; then
        echo "$subPackages" | sed "s,\(^\| \),\1./,g"
      else
        find . -type f -name \*$type.go -exec dirname {} \; | grep -v "/vendor/" | sort --unique | grep -v "$exclude"
      fi
    }
  '';

  installPhase = ''
    runHook preInstall

    make PREFIX=$out install

    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/vinegar \
      --prefix PATH : ${
        lib.makeBinPath [
          wine
          winetricks
        ]
      } \
      --set-default PUREGOTK_LIB_FOLDER ${finalAttrs.passthru.libraryPath}/lib
  '';

  passthru = {
    libraryPath = symlinkJoin {
      name = "vinegar-puregotk-lib-folder";
      paths = [
        cairo
        gdk-pixbuf
        glib.out
        graphene
        gtk4
        libadwaita
        pango.out
        vulkan-loader
      ];
    };

    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/vinegarhq/vinegar/releases/tag/v${finalAttrs.version}";
    description = "Open-source, minimal, configurable, fast bootstrapper for running Roblox Studio on Linux";
    homepage = "https://github.com/vinegarhq/vinegar";
    license = lib.licenses.gpl3Only;
    mainProgram = "vinegar";
    maintainers = with lib.maintainers; [
      HeitorAugustoLN
      jerryx77
    ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
