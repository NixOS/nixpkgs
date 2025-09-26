{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  fetchpatch2,
  davix,
  cmake,
  gtest,
  makeWrapper,
  pkg-config,
  curl,
  isa-l,
  fuse,
  libkrb5,
  libuuid,
  libxcrypt,
  libxml2,
  openssl,
  readline,
  scitokens-cpp,
  systemd,
  voms,
  zlib,
  # If not null, move the default configuration files to "$etc/etc" and look for the configuration
  # directory at externalEtc.
  # Otherwise, the program will look for the configuration files under $out/etc."
  externalEtc ? "/etc",
  removeReferencesTo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xrootd";
  version = "5.8.4";

  src = fetchFromGitHub {
    owner = "xrootd";
    repo = "xrootd";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-r0wXAlm+K6TE6189QyZL/k3q5IKlouSBKWzWXz1Tws4=";
  };

  patches = [
    # Downgrade -Wnull-dereference from error to warning
    # Should be removed in the release after next
    (fetchpatch2 {
      url = "https://github.com/xrootd/xrootd/commit/135b33b9631891219889fcaad449a4efb5e77d95.patch";
      hash = "sha256-t6Cy2XWp3B+sbMBxLhsh3WjQlXg4Tb7fF+rGGgYollU=";
    })
  ];

  postPatch = ''
    patchShebangs genversion.sh
    substituteInPlace cmake/XRootDConfig.cmake.in \
      --replace-fail "@PACKAGE_CMAKE_INSTALL_" "@CMAKE_INSTALL_FULL_"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    sed -i cmake/XRootDOSDefs.cmake -e '/set( MacOSX TRUE )/ainclude( GNUInstallDirs )'
  '';

  outputs = [
    "bin"
    "out"
    "dev"
    "man"
  ]
  ++ lib.optional (externalEtc != null) "etc";

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
    removeReferencesTo
  ];

  buildInputs = [
    davix
    curl
    libkrb5
    libuuid
    libxcrypt
    libxml2
    openssl
    readline
    scitokens-cpp
    zlib
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    # https://github.com/xrootd/xrootd/blob/5b5a1f6957def2816b77ec773c7e1bfb3f1cfc5b/cmake/XRootDFindLibs.cmake#L58
    fuse
  ]
  ++ lib.filter (lib.meta.availableOn stdenv.hostPlatform) [
    isa-l # not available on Apple silicon
    systemd # only available on specific non-static Linux platforms
    voms # only available on Linux due to gsoap failing to build on Darwin
  ];

  # https://github.com/xrootd/xrootd/blob/master/packaging/rhel/xrootd.spec.in#L665-L675=
  postInstall = ''
    mkdir -p "$out/lib/tmpfiles.d"
    install -m 644 -T ../packaging/rhel/xrootd.tmpfiles "$out/lib/tmpfiles.d/xrootd.conf"
    mkdir -p "$out/etc/xrootd"
    install -m 644 -t "$out/etc/xrootd" ../packaging/common/*.cfg
    install -m 644 -t "$out/etc/xrootd" ../packaging/common/client.conf
    mkdir -p "$out/etc/xrootd/client.plugins.d"
    install -m 644 -t "$out/etc/xrootd/client.plugins.d" ../packaging/common/client-plugin.conf.example
    mkdir -p "$out/etc/logrotate.d"
    install -m 644 -T ../packaging/common/xrootd.logrotate "$out/etc/logrotate.d/xrootd"
  ''
  # Leaving those in bin/ leads to a cyclic reference between $dev and $bin
  # This happens since https://github.com/xrootd/xrootd/commit/fe268eb622e2192d54a4230cea54c41660bd5788
  # So far, this xrootd-config script does not seem necessary in $bin
  + ''
    moveToOutput "bin/xrootd-config" "$dev"
    moveToOutput "bin/.xrootd-config-wrapped" "$dev"
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p "$out/lib/systemd/system"
    install -m 644 -t "$out/lib/systemd/system" ../packaging/common/*.service ../packaging/common/*.socket
  '';

  cmakeFlags = [
    (lib.cmakeFeature "XRootD_VERSION_STRING" finalAttrs.version)
    (lib.cmakeBool "FORCE_ENABLED" true)
    (lib.cmakeBool "ENABLE_DAVIX" true)
    (lib.cmakeBool "ENABLE_FUSE" (!stdenv.hostPlatform.isDarwin)) # XRootD doesn't support MacFUSE
    (lib.cmakeBool "ENABLE_MACAROONS" false)
    (lib.cmakeBool "ENABLE_PYTHON" false) # built separately
    (lib.cmakeBool "ENABLE_SCITOKENS" true)
    (lib.cmakeBool "ENABLE_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "ENABLE_VOMS" stdenv.hostPlatform.isLinux)
    (lib.cmakeBool "ENABLE_XRDEC" (lib.meta.availableOn stdenv.hostPlatform isa-l)) # requires isa-l
  ];

  # TODO(@ShamrockLee): Enable the checks.
  doCheck = false;
  checkInputs = [ gtest ];

  postFixup = lib.optionalString (externalEtc != null) ''
    moveToOutput etc "$etc"
    ln -s ${lib.escapeShellArg externalEtc} "$out/etc"
  '';

  dontPatchELF = true; # shrinking rpath will cause runtime failures in dlopen

  passthru = {
    fetchxrd = callPackage ./fetchxrd.nix { xrootd = finalAttrs.finalPackage; };
    tests = {
      test-xrdcp = finalAttrs.passthru.fetchxrd {
        pname = "xrootd-test-xrdcp";
        # Use the the bin output hash of xrootd as version to ensure that
        # the test gets rebuild everytime xrootd gets rebuild
        version =
          finalAttrs.version
          + "-"
          + builtins.substring (builtins.stringLength builtins.storeDir + 1) 32 "${finalAttrs.finalPackage}";
        url = "root://eospublic.cern.ch//eos/opendata/alice/2010/LHC10h/000138275/ESD/0000/AliESDs.root";
        hash = "sha256-tIcs2oi+8u/Qr+P7AAaPTbQT+DEt26gEdc4VNerlEHY=";
      };
    };
  };

  meta = {
    description = "High performance, scalable fault tolerant data access";
    homepage = "https://xrootd.slac.stanford.edu";
    changelog = "https://github.com/xrootd/xrootd/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ShamrockLee ];
  };
})
