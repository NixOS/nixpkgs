{
  lib,
  stdenv,
  fetchFromGitHub,
  Security,
  autoreconfHook,
  util-linux,
  openssl,
  cacert,
  # The primary --enable-XXX variant. 'all' enables most features, but causes build-errors for some software,
  # requiring to build a special variant for that software. Example: 'haproxy'
  variant ? "all",
  extraConfigureFlags ? [ ],
  enableARMCryptoExtensions ?
    stdenv.hostPlatform.isAarch64
    && ((builtins.match "^.*\\+crypto.*$" stdenv.hostPlatform.gcc.arch) != null),
  enableLto ? !(stdenv.hostPlatform.isStatic || stdenv.cc.isClang),
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wolfssl-${variant}";
  version = "5.7.4";

  src = fetchFromGitHub {
    owner = "wolfSSL";
    repo = "wolfssl";
    rev = "refs/tags/v${finalAttrs.version}-stable";
    hash = "sha256-/dtW1E1wYfQEuotclUEOK5+Vg4S7vt1xWhr1lEtu60w=";
  };

  postPatch = ''
    patchShebangs ./scripts
    # ensure test detects musl-based systems too
    substituteInPlace scripts/ocsp-stapling2.test \
      --replace '"linux-gnu"' '"linux-"'
  '';

  configureFlags =
    [
      "--enable-${variant}"
      "--enable-reproducible-build"
    ]
    ++ lib.optionals (variant == "all") [
      # Extra feature flags to add while building the 'all' variant.
      # Since they conflict while building other variants, only specify them for this one.
      "--enable-pkcs11"
      "--enable-writedup"
      "--enable-base64encode"
    ]
    ++ [
      # We're not on tiny embedded machines.
      # Increase TLS session cache from 33 sessions to 20k.
      "--enable-bigcache"

      # Use WolfSSL's Single Precision Math with timing-resistant cryptography.
      "--enable-sp=yes${
        lib.optionalString (stdenv.hostPlatform.isx86_64 || stdenv.hostPlatform.isAarch) ",asm"
      }"
      "--enable-sp-math-all"
      "--enable-harden"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isx86_64) [
      # Enable AVX/AVX2/AES-NI instructions, gated by runtime detection via CPUID.
      "--enable-intelasm"
      "--enable-aesni"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isAarch64) [
      # No runtime detection under ARM and no platform function checks like for X86.
      (if enableARMCryptoExtensions then "--enable-armasm=inline" else "--disable-armasm")
    ]
    ++ extraConfigureFlags;

  # Breaks tls13 tests on aarch64-darwin.
  hardeningDisable = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    "zerocallusedregs"
  ];

  # LTO should help with the C implementations.
  env.NIX_CFLAGS_COMPILE = lib.optionalString enableLto "-flto";
  env.NIX_LDFLAGS_COMPILE = lib.optionalString enableLto "-flto";

  # Don't attempt connections to external services in the test suite.
  env.WOLFSSL_EXTERNAL_TEST = "0";

  outputs = [
    "dev"
    "doc"
    "lib"
    "out"
  ];

  propagatedBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    Security
  ];

  nativeBuildInputs = [
    autoreconfHook
    util-linux
  ];

  doCheck = true;

  nativeCheckInputs = [
    openssl
    cacert
  ];

  postInstall = ''
    # fix recursive cycle:
    # wolfssl-config points to dev, dev propagates bin
    moveToOutput bin/wolfssl-config "$dev"
    # moveToOutput also removes "$out" so recreate it
    mkdir -p "$out"
  '';

  meta = with lib; {
    description = "Small, fast, portable implementation of TLS/SSL for embedded devices";
    mainProgram = "wolfssl-config";
    homepage = "https://www.wolfssl.com/";
    changelog = "https://github.com/wolfSSL/wolfssl/releases/tag/v${finalAttrs.version}-stable";
    platforms = platforms.all;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      fab
      vifino
    ];
  };
})
