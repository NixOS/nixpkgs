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
  version = "0.10.1-unstable-2026-05-21"; # fuse3 support, switch to openssl

  src = fetchFromGitHub {
    owner = "stefanberger";
    repo = "swtpm";
    rev = "89a67f3d4070887a1ab86ca641f8da13529c54b7";
    hash = "sha256-ebVfzKloJGmiaguxtcPC/MUuOQYzxIZDdi/0oEGXJ64=";
  };

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
