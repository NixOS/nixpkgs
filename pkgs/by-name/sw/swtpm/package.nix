{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  libtasn1,
  openssl,
  fuse3,
  glib,
  libseccomp,
  json-glib,
  libtpms,
  unixtools,
  expect,
  socat,
  gmp,
  gnutls,
  perl,
  makeWrapper,

  # Tests
  python3,
  which,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "swtpm";
  version = "0.10.1-unstable-2026-05-06"; # fuse3 support, switch to openssl, but does not yet require libtpms >= 0.11

  src = fetchFromGitHub {
    owner = "stefanberger";
    repo = "swtpm";
    rev = "74f272e337da2c2aa209140df85ddd43a285a2d9";
    hash = "sha256-cviADrmSTagba9KmlfiQFS6x4W/C8vI2/HuPRqZFh2U=";
  };

  patches = [
    (fetchpatch {
      # some miscellaneous fixes
      # - darwin support for socket open
      # - fix a typoed format string
      # - fix initializer lists to be compatible with clang
      url = "https://github.com/stefanberger/swtpm/pull/1127.patch";
      hash = "sha256-0DFf6LLdjv/wKcsjib1+AOJ3WWu83n5jA0Bx5/chlvc=";
    })
    (fetchpatch {
      # better detection of `stat` util
      url = "https://github.com/stefanberger/swtpm/pull/1128.patch";
      hash = "sha256-Cgt8No15NA/eCBLuKsYLDwVWO89XohnTQ3znd4Ky6NM=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    unixtools.netstat
    expect
    socat
    perl # for pod2man
    python3
    autoreconfHook
    makeWrapper
  ];

  nativeCheckInputs = [
    which
  ];

  buildInputs = [
    libtpms
    openssl
    libtasn1
    glib
    json-glib
    gmp
    gnutls
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    fuse3
    libseccomp
  ];

  configureFlags = [
    "--localstatedir=/var"
    "--with-gnutls"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "--with-cuse"
  ];

  postPatch = ''
    patchShebangs tests/*

    # Needed for cross-compilation
    substituteInPlace configure.ac --replace-fail 'pkg-config' '${stdenv.cc.targetPrefix}pkg-config'

    # Makefile tries to create the directory /var/lib/swtpm-localca, which fails
    substituteInPlace samples/Makefile.am \
        --replace-fail 'install-data-local:' 'do-not-execute:'

    # Use the correct path to the openssl binary
    # instead of relying on it being in the environment
    substituteInPlace src/swtpm_localca/swtpm_localca.c \
      --replace-fail \
        '#define OPENSSL_TOOL  "openssl"' \
        '#define OPENSSL_TOOL  "${lib.getExe openssl}"'
  '';

  # Workaround for https://github.com/stefanberger/swtpm/issues/795
  postFixup = ''
    wrapProgram "$out/bin/swtpm_localca" --suffix PATH : "$out/bin"
    wrapProgram "$out/bin/swtpm_setup" --suffix PATH : "$out/bin"
  '';

  doCheck = true;
  __darwinAllowLocalNetworking = true; # tests do socket things, requires local networking to pass
  enableParallelBuilding = true;

  outputs = [
    "out"
    "man"
  ];

  passthru.tests = { inherit (nixosTests) systemd-cryptenroll; };

  meta = {
    description = "Libtpms-based TPM emulator";
    homepage = "https://github.com/stefanberger/swtpm";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.baloo ];
    mainProgram = "swtpm";
    platforms = lib.platforms.all;
  };
})
