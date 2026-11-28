{
  lib,
  stdenv,
  fetchFromGitHub,
  ctrld,
  windscribe-wstunnel,
  fetchurl,
  cmake,
  ninja,
  pkg-config,
  makeBinaryWrapper,
  patchelf,
  qt6,
  boost188,
  miniaudio,
  libnl,
  libcap_ng,
  nftables,
  iptables,
  iproute2,
  networkmanager,
  openresolv,
  procps,
  spdlog,
  fmt,
  c-ares,
  openssl_4_0,
  curl,
  amneziawg-go,
  tl-expected,
  range-v3,
  nlohmann_json,
  acl,
  autoreconfHook,
  lzo,
  lz4,
  python3Packages,
  cmakerc,
  gtest,
  rapidjson,
  e2fsprogs,
  util-linux,
  kmod,
  iw,
  systemd,
  bash,
  coreutils,
  gnused,
  gnugrep,
  gawk,
  gnupg,
  ethtool,
  usePrebuiltWsnet ? false, # Override to true if you want full censorship-circumvention support
}:

let
  # Upstream Windscribe vcpkg port registry (contains custom crypto/tunnel patches)
  ws-vcpkg-registry = fetchFromGitHub {
    owner = "Windscribe";
    repo = "ws-vcpkg-registry";
    rev = "ef9b1277cc637891ca2b17638e21aa5d71f8f379";
    hash = "sha256-ZjXPjt1Hv8lXB39v6c50OAfnosKUdpHuzgnbt7d0SUE=";
  };

  # 1. Skyr URL
  skyr-url = stdenv.mkDerivation {
    pname = "skyr-url";
    version = "1.13.0";
    src = fetchFromGitHub {
      owner = "cpp-netlib";
      repo = "url";
      rev = "v1.13.0"; # matches https://github.com/Windscribe/ws-vcpkg-registry/blob/main/ports/skyr-url/portfile.cmake
      hash = "sha256-f+WcXdvsIGfXUIIK039DP3GS/BzOMbx9lH0G2ZM9NOg=";
    };
    nativeBuildInputs = [ cmake ];
    propagatedBuildInputs = [
      nlohmann_json
      range-v3
      tl-expected
    ];
    cmakeFlags = [
      "-Dskyr_BUILD_TESTS=OFF"
      "-Dskyr_BUILD_DOCS=OFF"
      "-Dskyr_BUILD_EXAMPLES=OFF"
      "-Dskyr_WARNINGS_AS_ERRORS=OFF"
      "-Dskyr_ENABLE_FILESYSTEM_FUNCTIONS=OFF"
    ];
  };

  # 2. OpenSSL with TLS Padding Support
  openssl-custom = openssl_4_0.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      "${ws-vcpkg-registry}/ports/openssl/tls-padding.patch"
    ];
  });

  # 3. cURL with Super-Large Padding & Legacy EC Point Formats
  curl-custom = (curl.override { openssl = openssl-custom; }).overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      "${ws-vcpkg-registry}/ports/curl/super-large-padding-extension.patch"
      "${ws-vcpkg-registry}/ports/curl/Export-SSL_OP_LEGACY_EC_POINT_FORMATS-OpenSSL-option.patch"
    ];
  });

  # 4. Inlined Header Dependencies for wsnet-source
  cpp-base64 = stdenv.mkDerivation {
    pname = "cpp-base64";
    version = "V2.rc.08";

    src = fetchFromGitHub {
      owner = "ReneNyffenegger";
      repo = "cpp-base64";
      rev = "V2.rc.08";
      hash = "sha256-6O0nmrC4pnzN4R3TOLCd+8cyje/n8mpCXX4lDYlXnHE=";
    };

    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/include/cpp-base64
      cp base64.* $out/include/cpp-base64/
      runHook postInstall
    '';
  };

  advobfuscatorSrc = fetchFromGitHub {
    owner = "andrivet";
    repo = "ADVobfuscator";
    rev = "1852a0eb75b03ab3139af7f938dfb617c292c600"; # legacy branch
    hash = "sha256-qleFYWPmCYHHtBO3Op3e8T6fxmC/3KwpatcQ8keiiz8=";
  };

  # 5A. wsnet compiled from source. Works perfectly fine on unrestricted networks
  wsnet-source = stdenv.mkDerivation (finalAttrs: {
    pname = "wsnet";
    version = "1.5.32";

    src = fetchFromGitHub {
      owner = "Windscribe";
      repo = "wsnet";
      rev = finalAttrs.version;
      hash = "sha256-W4qArEGc5Vk9HXoZlZxD8JEl9NRadJzZsKBYf5zZyOI=";
    };

    nativeBuildInputs = [
      cmake
      pkg-config
    ];

    buildInputs = [
      c-ares
      curl-custom
      openssl-custom
      spdlog
      rapidjson
      skyr-url
      boost188
      cmakerc
      gtest
    ];

    postPatch = ''
      substituteInPlace CMakeLists.txt \
        --replace-fail "find_package(CURL CONFIG REQUIRED)" "find_package(CURL REQUIRED)" \
        --replace-fail 'set(WSNET_VERSION_FALLBACK "0.0.0")' 'set(WSNET_VERSION_FALLBACK "${finalAttrs.version}")' \
        --replace-fail 'set(WSNET_GIT_DESCRIBE "unknown")' 'set(WSNET_GIT_DESCRIBE "v${finalAttrs.version}")'
    '';

    cmakeFlags = [
      "-DCPP_BASE64_INCLUDE_DIRS=${cpp-base64}/include"
      "-DADVOBFUSCATOR_INCLUDE_DIRS=${advobfuscatorSrc}"
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib $out/include $out/include/wsnet_internal
      install -m 755 libwsnet.so $out/lib/
      cp -r $src/include/* $out/include/

      cp wsnet_version.h $out/include/
      cp wsnet_version.h $out/include/wsnet_internal/

      cp -r $src/src/* $out/include/wsnet_internal/

      runHook postInstall
    '';
  });

  # 5B. wsnet prebuilt (Uses obfuscated censorship-circumvention stuff)
  wsnet-prebuilt = wsnet-source.overrideAttrs (old: {
    pname = "wsnet-prebuilt";

    srcDeb = fetchurl {
      url = "https://github.com/Windscribe/Desktop-App/releases/download/v2.24.13/windscribe_2.24.13_amd64.deb";
      hash = "sha256-eanxf898hY6NKzHM2umrfabjhA+8kKl0AQTLCsvOGZE=";
    };

    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ patchelf ];

    postInstall = (old.postInstall or "") + ''
      ar x $srcDeb data.tar.xz
      tar -xf data.tar.xz ./opt/windscribe/lib/libwsnet.so
      install -m 755 opt/windscribe/lib/libwsnet.so $out/lib/libwsnet.so
      rm -rf data.tar.xz opt

      patchelf \
        --set-rpath "${
          lib.makeLibraryPath [
            openssl-custom
            stdenv.cc.cc.lib
          ]
        }" \
        $out/lib/libwsnet.so
    '';
  });

  # Active wsnet dependency selection
  wsnet = if usePrebuiltWsnet then wsnet-prebuilt else wsnet-source;

  # 6. OpenVPN 2.7.5 with DCO & Anti-Censorship Patches
  windscribeopenvpn = stdenv.mkDerivation {
    pname = "windscribeopenvpn";
    version = "2.7.5";
    src = fetchFromGitHub {
      owner = "OpenVPN";
      repo = "openvpn";
      rev = "b25bb2a8bda814edab39b4246d4e296330a7a29e";
      hash = "sha256-oyKidDw+3PRmHezyftfYXqe8pIwF0Bnr4ue1Alq5zKc=";
    };
    nativeBuildInputs = [
      autoreconfHook
      pkg-config
    ];
    buildInputs = [
      openssl-custom
      lzo
      lz4
      libcap_ng
      libnl
    ];
    patches = [
      "${ws-vcpkg-registry}/ports/openvpn/anti-censorship.patch"
      "${ws-vcpkg-registry}/ports/openvpn/0002-Anti-censorship-add-support-for-Amnezia-s-Jc-Jmin-Jm.patch"
      "${ws-vcpkg-registry}/ports/openvpn/0003-Anti-censorship-introduce-junk-first-option-Jc-befor.patch"
    ];
    configureFlags = [
      "--with-crypto-library=openssl"
      "--disable-plugin-auth-pam"
      "--disable-plugin-down-root"
      "--enable-dco"
    ];
    installTargets = [ "install-exec" ];
    postInstall = ''
      mkdir -p $out/bin
      mv $out/sbin/openvpn $out/bin/openvpn
    '';
  };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "windscribe";
  version = "2.24.13";

  src = fetchFromGitHub {
    owner = "Windscribe";
    repo = "Desktop-App";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zpaEOrgFnxoZ/d6bAF0SlbB0q/+pGIxhWU8t0F16F/Q=";
  };

  patches = [
    ./nixos.patch
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail '@OPENVPN_VERSION@' "${windscribeopenvpn.version}"
    substituteInPlace cmake/integrations/windscribe.cmake \
      --replace-fail 'set(WS_POSIX_CONFIG_DIR "/etc/windscribe")' 'set(WS_POSIX_CONFIG_DIR "'"$out"'/etc/windscribe")' \
      --replace-fail 'set(WS_LINUX_INSTALL_DIR "/opt/windscribe")' 'set(WS_LINUX_INSTALL_DIR "'"$out"'/opt/windscribe")' \
      --replace-fail 'set(WS_LINUX_RUN_DIR "/var/run/windscribe")' 'set(WS_LINUX_RUN_DIR "/run/windscribe")'
  '';

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    qt6.wrapQtAppsHook
    makeBinaryWrapper
    bash
    python3Packages.python
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwayland
    qt6.qttools
    boost188
    miniaudio.dev
    libnl
    libcap_ng
    nftables
    spdlog
    fmt
    c-ares
    openssl-custom
    tl-expected
    range-v3
    nlohmann_json
    acl
    skyr-url
    wsnet
  ];

  NIX_CFLAGS_COMPILE = "-isystem ${miniaudio.dev}/include/miniaudio";

  cmakeFlags = [
    "-DBUILD_INSTALLER=OFF"
    "-DBUILD_DEB=OFF"
    "-DWSNET_DIR=${wsnet}"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/windscribe/lib $out/bin $out/share/applications $out/share/icons/hicolor $out/etc/windscribe/autostart

    # 1. Main Binaries & Shared Libraries
    install -m 755 src/client/Windscribe $out/opt/windscribe/Windscribe
    install -m 755 src/windscribe-cli/windscribe-cli $out/opt/windscribe/windscribe-cli
    install -m 755 src/helper/linux/helper $out/opt/windscribe/helper
    ln -s helper $out/opt/windscribe/windscribe-helper
    install -m 755 ${wsnet}/lib/libwsnet.so $out/opt/windscribe/lib/libwsnet.so

    # 2. Bundled Helper Executables
    install -m 755 ${ctrld}/bin/ctrld $out/opt/windscribe/windscribectrld
    ln -s ${amneziawg-go}/bin/amneziawg-go $out/opt/windscribe/windscribeamneziawg
    install -m 755 ${windscribe-wstunnel}/bin/windscribe-wstunnel $out/opt/windscribe/windscribewstunnel
    install -m 755 ${windscribeopenvpn}/bin/openvpn $out/opt/windscribe/windscribeopenvpn

    # 3. Scripts
    mkdir -p $out/opt/windscribe/scripts
    cp -r ../src/installer/windscribe/linux/opt/windscribe/scripts/* $out/opt/windscribe/scripts/

    rm -f $out/opt/windscribe/scripts/install-update
    install -m 755 ${./install-update.sh} $out/opt/windscribe/scripts/install-update

    rm $out/opt/windscribe/scripts/update-network-manager
    install -m 755 ${./update-network-manager.sh} $out/opt/windscribe/scripts/update-network-manager

    chmod -R u+w $out/opt/windscribe/scripts
    chmod -R +x $out/opt/windscribe/scripts

    for script in $out/opt/windscribe/scripts/*; do
      substituteInPlace "$script" \
        --replace-quiet '#!/bin/bash' '#!${lib.getExe bash}' \
        --replace-quiet '#!/usr/bin/env bash' '#!${lib.getExe bash}'
    done

    for script in $out/opt/windscribe/scripts/*; do
      wrapProgram "$script" \
        --prefix PATH : ${
          lib.makeBinPath [
            bash
            coreutils
            iproute2
            networkmanager
            openresolv
            systemd
            util-linux
            kmod
            gnused
            gnugrep
            gawk
            e2fsprogs
          ]
        }
    done

    # 4. Desktop Entries & Icons
    install -m 644 ../src/installer/gui/linux/overlay/usr/share/applications/windscribe.desktop $out/share/applications/windscribe.desktop
    substituteInPlace $out/share/applications/windscribe.desktop \
      --replace-fail "Exec=/opt/windscribe/Windscribe" "Exec=windscribe"

    install -m 644 ../src/installer/gui/linux/overlay/etc/windscribe/autostart/windscribe.desktop $out/etc/windscribe/autostart/windscribe.desktop
    substituteInPlace $out/etc/windscribe/autostart/windscribe.desktop \
      --replace-fail "Exec=/opt/windscribe/Windscribe" "Exec=windscribe"

    for size in 16x16 24x24 32x32 48x48 64x64 128x128 256x256; do
      iconDir="$out/share/icons/hicolor/$size/apps"
      mkdir -p "$iconDir"
      install -m 644 "../src/installer/gui/linux/png_icons/$size/windscribe.png" "$iconDir/Windscribe.png"
      ln -sf Windscribe.png "$iconDir/windscribe.png"
    done

    # 5. CLI & GUI Wrappers
    mkdir -p $out/bin
    ln -sf ../opt/windscribe/windscribe-cli $out/bin/windscribe-cli
    ln -sf ../opt/windscribe/helper $out/bin/windscribe-helper
    ln -sf ../opt/windscribe/Windscribe $out/bin/windscribe

    runHook postInstall
  '';

  postFixup = ''
    wrapQtApp "$out/opt/windscribe/Windscribe"
    wrapQtApp "$out/opt/windscribe/windscribe-cli"
    wrapProgram "$out/opt/windscribe/helper" --prefix PATH : ${
      lib.makeBinPath [
        iproute2
        iptables
        nftables
        procps
        systemd
        networkmanager
        coreutils
        util-linux
        kmod
        ethtool
        iw
        e2fsprogs
        gnused
        gnugrep
        gnupg
        gawk
      ]
    }
  '';

  meta = {
    description = "Windscribe Desktop VPN Client and Helper Suite";
    homepage = "https://windscribe.com";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ aliheidary1381 ];
    platforms = with lib.platforms; linux ++ darwin;
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "windscribe";
  };
})
