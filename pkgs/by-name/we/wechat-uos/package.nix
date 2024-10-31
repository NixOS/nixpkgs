{ stdenvNoCC
, stdenv
, lib
, fetchurl
, requireFile
, dpkg
, nss
, nspr
, xorg
, pango
, zlib
, atkmm
, libdrm
, libxkbcommon
, xcbutilwm
, xcbutilimage
, xcbutilkeysyms
, xcbutilrenderutil
, mesa
, alsa-lib
, wayland
, atk
, qt6
, at-spi2-atk
, at-spi2-core
, dbus
, cups
, gtk3
, libxml2
, cairo
, freetype
, fontconfig
, vulkan-loader
, gdk-pixbuf
, libexif
, ffmpeg
, pulseaudio
, systemd
, libuuid
, expat
, bzip2
, glib
, libva
, libGL
, libnotify
, buildFHSEnv
, writeShellScript
, /**
  License for wechat-uos, packed in a gz archive named "license.tar.gz".
  It should have the following files:
  license.tar.gz
  ├── etc
  │   ├── lsb-release
  │   └── os-release
  └── var
      ├── lib
      │   └── uos-license
      │       └── .license.json
      └── uos
          └── .license.key
  */
  uosLicense ? null
}:
let
  # zerocallusedregs hardening breaks WeChat
  glibcWithoutHardening = stdenv.cc.libc.overrideAttrs (old: {
    hardeningDisable = (old.hardeningDisable or [ ]) ++ [ "zerocallusedregs" ];
  });

  wechat-uos-env = stdenvNoCC.mkDerivation {
    meta.priority = 1;
    name = "wechat-uos-env";
    buildCommand = ''
      mkdir -p $out/etc
      mkdir -p $out/lib/license
      mkdir -p $out/usr/bin
      mkdir -p $out/usr/share
      mkdir -p $out/opt
      mkdir -p $out/var

      ln -s ${wechat}/opt/* $out/opt/
      ln -s ${wechat}/usr/lib/wechat-uos/license/etc/os-release  $out/etc/os-release
      ln -s ${wechat}/usr/lib/wechat-uos/license/etc/lsb-release  $out/etc/lsb-release
      ln -s ${wechat}/usr/lib/wechat-uos/license/var/*  $out/var/
      ln -s ${wechat}/usr/lib/wechat-uos/license/libuosdevicea.so $out/lib/license/
    '';
    preferLocalBuild = true;
  };

  uosLicenseUnzipped = stdenvNoCC.mkDerivation {
    name = "uos-license-unzipped";
    src =
      if uosLicense == null then
        requireFile
          {
            name = "license.tar.gz";
            url = "https://www.uniontech.com";
            hash = "sha256-U3YAecGltY8vo9Xv/h7TUjlZCyiIQdgSIp705VstvWk=";
          } else uosLicense;

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r * $out/

      runHook postInstall
    '';
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-pNftwtUZqBsKBSPQsEWlYLlb6h2Xd9j56ZRMi8I82ME=";
  };

  libuosdevicea = stdenv.mkDerivation rec {
    name = "libuosdevicea";
    src = ./libuosdevicea.c;

    unpackPhase = ''
      runHook preUnpack

      cp ${src} libuosdevicea.c

      runHook postUnpack
    '';

    buildPhase = ''
      runHook preBuild

      $CC -shared -fPIC -o libuosdevicea.so libuosdevicea.c

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib
      cp libuosdevicea.so $out/lib/

      runHook postInstall
    '';

    meta = with lib; {
      license = licenses.gpl2Plus;
    };
  };

  wechat-uos-runtime = with xorg; [
    # Make sure our glibc without hardening gets picked up first
    (lib.hiPrio glibcWithoutHardening)

    stdenv.cc.cc
    stdenv.cc.libc
    pango
    zlib
    xcbutilwm
    xcbutilimage
    xcbutilkeysyms
    xcbutilrenderutil
    libX11
    libXt
    libXext
    libSM
    libICE
    libxcb
    libxkbcommon
    libxshmfence
    libXi
    libXft
    libXcursor
    libXfixes
    libXScrnSaver
    libXcomposite
    libXdamage
    libXtst
    libXrandr
    libnotify
    atk
    atkmm
    cairo
    at-spi2-atk
    at-spi2-core
    alsa-lib
    dbus
    cups
    gtk3
    gdk-pixbuf
    libexif
    ffmpeg
    libva
    freetype
    fontconfig
    libXrender
    libuuid
    expat
    glib
    nss
    nspr
    libGL
    libxml2
    pango
    libdrm
    mesa
    vulkan-loader
    systemd
    wayland
    pulseaudio
    qt6.qt5compat
    bzip2
  ];

  sources = import ./sources.nix;

  wechat = stdenvNoCC.mkDerivation
    rec {
      pname = "wechat-uos";
      version = sources.version;

      src = {
        x86_64-linux = fetchurl {
          url = sources.amd64_url;
          hash = sources.amd64_hash;
        };
        aarch64-linux = fetchurl {
          url = sources.arm64_url;
          hash = sources.arm64_hash;
        };
        loongarch64-linux = fetchurl {
          url = sources.loongarch64_url;
          hash = sources.loongarch64_hash;
        };
      }.${stdenv.system} or (throw "${pname}-${version}: ${stdenv.system} is unsupported.");

      inherit uosLicense;

      nativeBuildInputs = [ dpkg ];

      unpackPhase = ''
        runHook preUnpack

        dpkg -x $src ./wechat-uos

        runHook postUnpack
      '';

      # Use ln for license to prevent being garbage collection
      installPhase = ''
        runHook preInstall
        mkdir -p $out

        cp -r wechat-uos/* $out

        mkdir -pv $out/usr/lib/wechat-uos/license
        ln -s ${uosLicenseUnzipped}/* $out/usr/lib/wechat-uos/license/
        ln -s ${libuosdevicea}/lib/libuosdevicea.so $out/usr/lib/wechat-uos/license/

        runHook postInstall
      '';

      meta = with lib; {
        description = "Messaging app";
        homepage = "https://weixin.qq.com/";
        license = licenses.unfree;
        platforms = [ "x86_64-linux" "aarch64-linux" "loongarch64-linux" ];
        sourceProvenance = with sourceTypes; [ binaryNativeCode ];
        maintainers = with maintainers; [ pokon548 xddxdd ];
        mainProgram = "wechat-uos";
      };
    };
in
buildFHSEnv {
  inherit (wechat) name meta;
  runScript = writeShellScript "wechat-uos-launcher" ''
    export QT_QPA_PLATFORM=xcb
    export LD_LIBRARY_PATH=${lib.makeLibraryPath wechat-uos-runtime}

    if [[ ''${XMODIFIERS} =~ fcitx ]]; then
      export QT_IM_MODULE=fcitx
      export GTK_IM_MODULE=fcitx
    elif [[ ''${XMODIFIERS} =~ ibus ]]; then
      export QT_IM_MODULE=ibus
      export GTK_IM_MODULE=ibus
      export IBUS_USE_PORTAL=1
    fi

    ${wechat.outPath}/opt/apps/com.tencent.wechat/files/wechat
  '';
  extraInstallCommands = ''
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons
    cp -r ${wechat.outPath}/opt/apps/com.tencent.wechat/entries/applications/com.tencent.wechat.desktop $out/share/applications
    cp -r ${wechat.outPath}/opt/apps/com.tencent.wechat/entries/icons/* $out/share/icons/

    mv $out/bin/$name $out/bin/wechat-uos

    substituteInPlace $out/share/applications/com.tencent.wechat.desktop \
      --replace-quiet 'Exec=/usr/bin/wechat' "Exec=$out/bin/wechat-uos --"
  '';
  targetPkgs = pkgs: [ wechat-uos-env ];

  passthru.updateScript = ./update.sh;

  extraOutputsToInstall = [ "usr" "var/lib/uos" "var/uos" "etc" ];
}
