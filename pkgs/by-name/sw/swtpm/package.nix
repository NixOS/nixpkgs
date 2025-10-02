{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  libtasn1,
  openssl,
  fuse,
  glib,
  libseccomp,
  json-glib,
  libtpms,
  unixtools,
  expect,
  socat,
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
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "stefanberger";
    repo = "swtpm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-N79vuI0FhawLyQtwVF6ABIvCmEaYefq/YkyrafUfUHE=";
  };

  patches = [
    (fetchpatch {
      name = "retry-nwwrite.patch";
      url = "https://github.com/stefanberger/swtpm/commit/4da66c66f92438443e66b67555673c9cb898b0ae.patch";
      hash = "sha256-TTS+ViN4g6EfNLrhvGPobcSQEbr/mEl9ZLZTWdxbifs=";
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
    gnutls
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    fuse
    libseccomp
  ];

  configureFlags = [
    "--localstatedir=/var"
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
        --replace 'install-data-local:' 'do-not-execute:'

    # Use the correct path to the certtool binary
    # instead of relying on it being in the environment
    substituteInPlace src/swtpm_localca/swtpm_localca.c \
      --replace \
        '# define CERTTOOL_NAME "gnutls-certtool"' \
        '# define CERTTOOL_NAME "${gnutls}/bin/certtool"' \
      --replace \
        '# define CERTTOOL_NAME "certtool"' \
        '# define CERTTOOL_NAME "${gnutls}/bin/certtool"'

    substituteInPlace tests/common --replace \
        'CERTTOOL=gnutls-certtool;;' \
        'CERTTOOL=certtool;;'

    # Fix error on macOS:
    # stat: invalid option -- '%'
    # This is caused by the stat program not being the BSD version,
    # as is expected by the test
    substituteInPlace tests/common tests/sed-inplace --replace \
        'if [[ "$(uname -s)" =~ (Linux|CYGWIN_NT-) ]]; then' \
        'if [[ "$(uname -s)" =~ (Linux|Darwin|CYGWIN_NT-) ]]; then'

    # Otherwise certtool seems to pick up the system language on macOS,
    # which might cause a test to fail
    substituteInPlace tests/test_swtpm_setup_create_cert --replace \
        '$CERTTOOL' \
        'LC_ALL=C.UTF-8 $CERTTOOL'

    substituteInPlace tests/test_tpm2_swtpm_cert --replace \
        'certtool' \
        'LC_ALL=C.UTF-8 certtool'
  '';

  # Workaround for https://github.com/stefanberger/swtpm/issues/795
  postFixup = ''
    wrapProgram "$out/bin/swtpm_localca" --suffix PATH : "$out/bin"
    wrapProgram "$out/bin/swtpm_setup" --suffix PATH : "$out/bin"
  '';

  doCheck = true;
  enableParallelBuilding = true;

  outputs = [
    "out"
    "man"
  ];

  passthru.tests = { inherit (nixosTests) systemd-cryptenroll; };

  meta = with lib; {
    description = "Libtpms-based TPM emulator";
    homepage = "https://github.com/stefanberger/swtpm";
    license = licenses.bsd3;
    maintainers = [ maintainers.baloo ];
    mainProgram = "swtpm";
    platforms = platforms.all;
  };
})
