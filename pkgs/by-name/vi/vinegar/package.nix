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
  # Based on wine 11.19
  kombuchaPatches = fetchFromGitHub {
    name = "kombucha";
    owner = "vinegarhq";
    repo = "kombucha";
    rev = "f72e02afb19b400d29958fde0cf2b183a92bb300";
    hash = "sha256-FLFKL9h+8LUCVTk6aG3UY7M0EhdhOtdSCcObPpGvi94=";
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
        # https://github.com/vinegarhq/kombucha/blob/f72e02afb19b400d29958fde0cf2b183a92bb300/.github/workflows/build.yml
        configureFlags = lib.remove "--enable-win64" (oldAttrs.configureFlags or [ ]) ++ [
          "--disable-dxdiagn"
          "--disable-mscoree"
          "--disable-mshtml"
          "--disable-tests"
          "--disable-win16"
          "--disable-winedbg"
          "--disable-winemenubuilder"
          "--enable-archs=x86_64"
          "--with-mingw"
          "--without-alsa"
        ];

        patches =
          oldAttrs.patches or [ ]
          ++ map (name: "${kombuchaPatches}/patches/stable/${name}") [
            "0001-explorer-Enable-virtual-desktop-shell-by-default.patch"
            "0002-ntdll-Add-kombucha_hacks.patch"
            "0003-ntdll-Keep-more-LFH-block-groups-alive.patch"
            "0004-ntdll-HACK-Search-for-ucrtbase-using-common-rules.patch"
            "0005-ntdll-Use-default-loadorder-for-DXVK-DLLs.patch"
            "0006-server-Force-persistence-to-0-seconds.patch"
            "0007-server-Notify-if-ntsync-is-unavailable.patch"
            "0008-win32u-Apply-work-area-changes-to-virtual-desktop-mo.patch"
            "0009-explorer-Account-for-the-actual-size-of-the-taskbar-.patch"
            "0010-explorer-Update-system-work-area-rect-to-exclude-tas.patch"
            "0011-win32u-Don-t-load-bitmap-only-TTF-fonts-without-bitm.patch"
            "0012-wine.inf-Add-KombuchaOverrides.patch"
            "0013-wineboot-Add-WINEBOOT_HIDE_DIALOG-environment-variab.patch"
            "0014-winewayland-Add-warning-regarding-experimental-statu.patch"
            "0015-winex11.drv-Move-Xfixes-extension-query-to-process_a.patch"
            "0016-winex11-Use-XFixes-to-hide-cursor-before-warping-it.patch"
            "0017-winex11-Don-t-hide-cursor-under-X11-sessions.patch"
            "0018-winex11-Raise-hidden-windows-above-siblings-in-virtu.patch"
            "0019-server-print-tag-and-wine-commit-to-stdout.patch"
          ];

        postPatch = (oldAttrs.postPatch or "") + ''
          substituteInPlace server/main.c \
            --replace-fail 'using TAG, built from WINE_COMMIT.' 'using stable+20261009201837, built from Wine ${oldAttrs.version}.'
        '';
      });
in
buildGoModule (finalAttrs: {
  pname = "vinegar";
  version = "1.9.4";

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
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
