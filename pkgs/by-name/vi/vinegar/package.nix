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
}:
let
  # Based on wine 11.0
  kombuchaPatches = fetchFromGitHub {
    name = "kombucha";
    owner = "vinegarhq";
    repo = "kombucha";
    rev = "05927db95b427cc5e57856087325806cb20a0124";
    hash = "sha256-gyyf/TVKrc6/cGP9fNKr5+qMo7ucg8l/VIklhVP8kLg=";
    meta.license = lib.licenses.lgpl21Only;
  };

  wine =
    (wine64Packages.stable.override {
      dbusSupport = true;
      embedInstallers = true;
      pulseaudioSupport = true;
      x11Support = true;
      waylandSupport = true;
    }).overrideAttrs
      (oldAttrs: {
        # https://github.com/vinegarhq/kombucha/blob/80f87fdbaae2a42bd66e41319054798fdf30fbe6/.github/workflows/wine.yml
        # --with-wayland is added by waylandSupport = true;
        configureFlags = oldAttrs.configureFlags or [ ] ++ [
          "--disable-tests"
          "--disable-win16"
          "--with-dbus"
          "--with-pulse"
          "--with-x"
          "--without-oss"
          "--without-capi"
          "--without-cups"
          "--without-gphoto"
          "--without-gssapi"
          "--without-gstreamer"
          "--without-krb5"
          "--without-netapi"
          "--without-opencl"
          "--without-pcap"
          "--without-sane"
          "--without-v4l2"
        ];

        patches =
          oldAttrs.patches or [ ]
          ++ map (name: "${kombuchaPatches}/patches/${name}") [
            /*
              We can't apply these because they have binary content:

              "0001-fonts-Add-Liberation-Sans-as-an-Arial-replacement.-v.patch"
              "0002-fonts-Add-Liberation-Serif-as-an-Times-New-Roman-rep.patch"
              "0003-fonts-Add-Liberation-Mono-as-an-Courier-New-replacem.patch"
              "0004-fonts-Add-WenQuanYi-Micro-Hei-as-a-Microsoft-Yahei-r.patch"
              "0005-Add-licenses-for-fonts-as-separate-files.patch"
            */
            "0006-winecfg-Add-staging-tab-for-CSMT.patch"
            "0007-winecfg-Add-checkbox-to-enable-disable-vaapi-GPU-dec.patch"
            "0008-winecfg-Add-checkbox-to-enable-disable-EAX-support.patch"
            "0009-winecfg-Add-checkbox-to-enable-disable-HideWineExpor.patch"
            "0010-winecfg-Add-option-to-enable-disable-GTK3-theming.patch"
            "0011-winecfg-Move-input-config-options-to-a-dedicated-tab.patch"
            "0012-winex11-Always-create-the-HKCU-configuration-registr.patch"
            "0013-winex11-Write-supported-keyboard-layout-list-in-regi.patch"
            "0014-winecfg-Add-a-keyboard-layout-selection-config-optio.patch"
            "0015-winex11-Use-the-user-configured-keyboard-layout-if-a.patch"
            "0016-winecfg-Add-a-keyboard-scancode-detection-toggle-opt.patch"
            "0017-winex11-Use-scancode-high-bit-to-set-KEYEVENTF_EXTEN.patch"
            "0018-winex11-Support-fixed-X11-keycode-to-scancode-conver.patch"
            "0019-winex11-Disable-keyboard-scancode-auto-detection-by-.patch"
            "0020-win32u-Don-t-load-bitmap-only-TTF-fonts-without-bitm.patch"
            "0021-winex11-Move-Xfixes-extension-query-to-process_attac.patch"
            "0022-winex11-Add-Xwayland-check.patch"
            "0023-winex11-Use-XFixes-to-hide-cursor-before-warping-it.patch"
            "0024-winex11-Always-ignore-MotionNotify-event-after-SetCu.patch"
            "0025-winedbg-Disable.patch"
            "0026-wine.inf-Disable-unused-services.patch"
          ];
      });
in
buildGoModule (finalAttrs: {
  pname = "vinegar";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "vinegarhq";
    repo = "vinegar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0MNUkfhbsvOJdN89VGTuf3zHUFhimiCNuoY47V03Cgo=";
  };

  vendorHash = "sha256-gzy7Lw7AP1evPSDSzMQb/yzn+8uVtyk8TOBL2fjE3R8=";

  nativeBuildInputs = [
    glib
    makeBinaryWrapper
    pkg-config
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
    substituteInPlace internal/config/values.go \
      --replace-fail 'return dirs.WinePath' 'return "${wine}"' \
      --replace-fail '"github.com/vinegarhq/vinegar/internal/dirs"' ""
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
