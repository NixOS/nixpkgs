{
  lib,
  stdenv,
  fetchurl,
  cmake,
  pkg-config,
  libffi,
  boehmgc,
  openssl,
  zlib,
  odbcSupport ? !stdenv.isDarwin,
  libiodbc,
}:

let
  platformLdLibraryPath =
    if stdenv.isDarwin then
      "DYLD_FALLBACK_LIBRARY_PATH"
    else if (stdenv.isLinux or stdenv.isBSD) then
      "LD_LIBRARY_PATH"
    else
      throw "unsupported platform";
in
stdenv.mkDerivation rec {
  pname = "sagittarius-scheme";
  version = "0.9.11";
  src = fetchurl {
    url = "https://bitbucket.org/ktakashi/${pname}/downloads/sagittarius-${version}.tar.gz";
    hash = "sha256-LIF1EW8sMBMKycQnVAXk+5iEpKmRHMmzBILAg2tjk8c=";
  };
  preBuild = ''
    # since we lack rpath during build, need to explicitly add build path
    # to LD_LIBRARY_PATH so we can load libsagittarius.so as required to
    # build extensions
    export ${platformLdLibraryPath}="$(pwd)/build"
  '';
  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    libffi
    boehmgc
    openssl
    zlib
  ] ++ lib.optional odbcSupport libiodbc;

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.isDarwin [
      "-Wno-error=int-conversion"
    ]
    ++ lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
      # error: '__builtin_ia32_aeskeygenassist128' needs target feature aes
      "-maes"
    ]
  );

  meta = with lib; {
    description = "An R6RS/R7RS Scheme system";
    longDescription = ''
      Sagittarius Scheme is a free Scheme implementation supporting
      R6RS/R7RS specification.

      Features:

      -  Builtin CLOS.
      -  Common Lisp like reader macro.
      -  Cryptographic libraries.
      -  Customisable cipher and hash algorithm.
      -  Custom codec mechanism.
      -  CL like keyword lambda syntax (taken from Gauche).
      -  Constant definition form. (define-constant form).
      -  Builtin regular expression
      -  mostly works O(n)
      -  Replaceable reader
    '';
    homepage = "https://bitbucket.org/ktakashi/sagittarius-scheme";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ abbe ];
  };
}
