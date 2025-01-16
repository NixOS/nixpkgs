{
  lib,
  stdenv,
  fetchurl,
  buildPackages,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  curl,
  dbus,
  dpkg,
  expat,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gst_all_1,
  adwaita-icon-theme,
  gsettings-desktop-schemas,
  gtk3,
  gtk4,
  qt6,
  libX11,
  libXScrnSaver,
  libXcomposite,
  libXcursor,
  libXdamage,
  libXext,
  libXfixes,
  libXi,
  libXrandr,
  libXrender,
  libXtst,
  libdrm,
  libkrb5,
  libuuid,
  libxkbcommon,
  libxshmfence,
  libgbm,
  mesa,
  nspr,
  nss,
  pango,
  pipewire,
  snappy,
  udev,
  wayland,
  xdg-utils,
  coreutils,
  xorg,
  zlib,
  yandex-ffmpeg-codecs,
  flutter,

  # command line arguments which are always set e.g "--disable-gpu"
  commandLineArgs ? "",

  # Necessary for USB audio devices.
  pulseSupport ? stdenv.hostPlatform.isLinux,
  libpulseaudio,

  # For GPU acceleration support on Wayland (without the lib it doesn't seem to work)
  libGL,
  libGLU,

  # For video acceleration via VA-API (--enable-features=VaapiVideoDecoder,VaapiVideoEncoder)
  libvaSupport ? stdenv.hostPlatform.isLinux,
  libva,
  enableVideoAcceleration ? libvaSupport,

  # For Vulkan support (--enable-features=Vulkan); disabled by default as it seems to break VA-API
  vulkanSupport ? false,
  addDriverRunpath,
  enableVulkan ? vulkanSupport,
  vulkan-loader,

  edition,
}:

{
  pname,
  version,
  hash,
  url,
  app,
}:

let
  inherit (lib)
    optional
    optionals
    makeLibraryPath
    makeSearchPathOutput
    makeBinPath
    optionalString
    strings
    escapeShellArg
    ;

  deps =
    [
      alsa-lib
      atk
      at-spi2-atk
      at-spi2-core
      cairo
      cups
      curl
      dbus
      expat
      flutter
      fontconfig
      freetype
      gdk-pixbuf
      glib
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gstreamer
      gtk3
      gtk4
      libdrm
      libgbm
      libGL
      libGLU
      libkrb5
      libuuid
      libX11
      libXcomposite
      libXcursor
      libXdamage
      libXext
      libXfixes
      libXi
      libxkbcommon
      libXrandr
      libXrender
      libXScrnSaver
      libxshmfence
      libXtst
      mesa
      mesa.drivers
      nspr
      nss
      pango
      pipewire
      qt6.qtbase
      snappy
      udev
      vulkan-loader
      wayland
      xorg.libX11
      xorg.libxcb
      xorg.libXcomposite
      xorg.libXext
      xorg.libXi
      xorg.libXrandr
      xorg.libXxf86vm
      yandex-ffmpeg-codecs
      zlib
    ]
    ++ optional pulseSupport libpulseaudio
    ++ optional libvaSupport libva;

  rpath = makeLibraryPath deps + ":" + makeSearchPathOutput "lib" "lib64" deps;
  binpath = makeBinPath deps;

  enableFeatures =
    optionals enableVideoAcceleration [
      "VaapiVideoDecoder"
      "VaapiVideoEncoder"
    ]
    ++ optional enableVulkan "Vulkan";

  disableFeatures =
    [ "OutdatedBuildDetector" ] # disable automatic updates
    # The feature disable is needed for VAAPI to work correctly.
    ++ optionals enableVideoAcceleration [ "UseChromeOSDirectVideoDecoder" ];
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    inherit url hash;
  };

  dontConfigure = true;
  dontBuild = true;
  dontPatchELF = true;
  doInstallCheck = stdenv.hostPlatform.isLinux;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    dpkg
    # override doesn't preserve splicing https://github.com/NixOS/nixpkgs/issues/132651
    # Has to use `makeShellWrapper` from `buildPackages` even though `makeShellWrapper` from the inputs is spliced because `propagatedBuildInputs` would pick the wrong one because of a different offset.
    (buildPackages.wrapGAppsHook3.override { makeWrapper = buildPackages.makeShellWrapper; })
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    # needed for GSETTINGS_SCHEMAS_PATH
    glib
    gsettings-desktop-schemas
    gtk3
    gtk4

    # needed for XDG_ICON_DIRS
    adwaita-icon-theme
  ];

  installPhase = lib.optionalString stdenv.hostPlatform.isLinux ''
    runHook preInstall

    mkdir -p $out $out/bin

    cp -R usr/share $out
    cp -R opt/ $out/opt

    export BINARYWRAPPER=$out/opt/yandex/browser${app}/yandex-browser${app}

    # Fix path to bash in $BINARYWRAPPER
    substituteInPlace $BINARYWRAPPER \
        --replace-quiet /bin/bash ${stdenv.shell}

    ln -sf $BINARYWRAPPER $out/bin/yandex-browser-${edition}

    for exe in $out/opt/yandex/browser${app}/{yandex_browser,chrome_crashpad_handler,find_ffmpeg}; do
        patchelf \
            --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
            --set-rpath "${rpath}" $exe
    done

    # Fix paths
    substituteInPlace $out/share/applications/yandex-browser${app}.desktop \
        --replace-quiet /usr/bin/yandex-browser-${edition} $out/bin/yandex-browser-${edition}
    substituteInPlace $out/share/gnome-control-center/default-apps/yandex-browser${app}.xml \
        --replace-quiet /opt/yandex $out/opt/yandex
    substituteInPlace $out/share/menu/yandex-browser${app}.menu \
        --replace-quiet /opt/yandex $out/opt/yandex
    substituteInPlace $out/opt/yandex/browser${app}/default-app-block \
        --replace-quiet /opt/yandex $out/opt/yandex

    # Correct icons location
    icon_sizes=("16" "24" "32" "48" "64" "128" "256")

    for icon in ''${icon_sizes[*]}
    do
        mkdir -p $out/share/icons/hicolor/$icon\x$icon/apps
        ln -s $out/opt/yandex/browser${app}/product_logo_$icon.png $out/share/icons/hicolor/$icon\x$icon/apps/yandex-browser.png
    done

    # Replace xdg-settings and xdg-mime
    ln -sf ${xdg-utils}/bin/xdg-settings $out/opt/yandex/browser${app}/xdg-settings
    ln -sf ${xdg-utils}/bin/xdg-mime $out/opt/yandex/browser${app}/xdg-mime

    ln -sf ${yandex-ffmpeg-codecs}/lib/libffmpeg.so $out/opt/yandex/browser${app}/libffmpeg.so

    runHook postInstall
  '';

  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-needed "libGL.so.1" "$out/opt/yandex/browser${app}/yandex_browser"
    # Add command line args to wrapGApp.
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : ${rpath}
      --prefix PATH : ${binpath}
      --suffix PATH : ${
        lib.makeBinPath [
          xdg-utils
          coreutils
        ]
      }
      --set LIBGL_DRIVERS_PATH "${mesa.drivers}/lib/dri"
      --set GBM_BACKENDS_PATH "${mesa.drivers}/lib/gbm"
      ${optionalString (enableFeatures != [ ]) ''
        --add-flags "--enable-features=${strings.concatStringsSep "," enableFeatures}\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+,WaylandWindowDecorations --enable-wayland-ime=true}}"
      ''}
      ${optionalString (disableFeatures != [ ]) ''
        --add-flags "--disable-features=${strings.concatStringsSep "," disableFeatures}"
      ''}
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto}}"
      ${optionalString vulkanSupport ''
        --prefix XDG_DATA_DIRS  : "${addDriverRunpath.driverLink}/share"
      ''}
      --add-flags "--in-process-gpu"
      --add-flags "--disable-gpu-compositing"
      --add-flags ${escapeShellArg commandLineArgs}
    )
  '';

  installCheckPhase = ''
    # Bypass upstream wrapper which suppresses errors
    $out/opt/yandex/browser${app}/yandex_browser --version
  '';

  meta = {
    homepage = "https://browser.yandex.ru/";
    description = "Yandex Web Browser";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      dan4ik605743
      ionutnechita
    ];
    platforms = [
      "x86_64-linux"
    ];

    knownVulnerabilities = [
      ''
        Trusts a Russian government issued CA certificate for some websites.
        See https://habr.com/en/company/yandex/blog/655185/ (Russian) for details.
      ''
    ];

  };
}
