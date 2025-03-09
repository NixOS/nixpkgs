{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  automake,
  autoconf,
  libtool,
  autoreconfHook,
  gmpxx,
}:
stdenv.mkDerivation rec {
  pname = "givaro";
  version = "4.2.0";
  src = fetchFromGitHub {
    owner = "linbox-team";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KR0WJc0CSvaBnPRott4hQJhWNBb/Wi6MIhcTExtVobQ=";
  };
  patches = [
    # Pull upstream fix for gcc-13:
    #   https://github.com/linbox-team/givaro/pull/218
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/linbox-team/givaro/commit/c7744bb133496cd7ac04688f345646d505e1bf52.patch";
      hash = "sha256-aAA5o8Va10v0Pqgcpx7qM0TAZiNQgXoR6N9xecj7tDA=";
    })
    (fetchpatch {
      name = "clang-16.patch";
      url = "https://github.com/linbox-team/givaro/commit/a81d44b3b57c275bcb04ab00db79be02561deaa2.patch";
      hash = "sha256-sSk+VWffoEjZRTJcHRISLHPyW6yuvI1u8knBOfxNUIE=";
    })
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook
    autoconf
    automake
  ];
  buildInputs = [ libtool ];
  propagatedBuildInputs = [ gmpxx ];

  configureFlags =
    [
      "--without-archnative"
    ]
    ++ lib.optionals stdenv.hostPlatform.isx86_64 [
      # disable SIMD instructions (which are enabled *when available* by default)
      "--${if stdenv.hostPlatform.sse3Support then "enable" else "disable"}-sse3"
      "--${if stdenv.hostPlatform.ssse3Support then "enable" else "disable"}-ssse3"
      "--${if stdenv.hostPlatform.sse4_1Support then "enable" else "disable"}-sse41"
      "--${if stdenv.hostPlatform.sse4_2Support then "enable" else "disable"}-sse42"
      "--${if stdenv.hostPlatform.avxSupport then "enable" else "disable"}-avx"
      "--${if stdenv.hostPlatform.avx2Support then "enable" else "disable"}-avx2"
      "--${if stdenv.hostPlatform.fmaSupport then "enable" else "disable"}-fma"
      "--${if stdenv.hostPlatform.fma4Support then "enable" else "disable"}-fma4"
    ];

  # On darwin, tests are linked to dylib in the nix store, so we need to make
  # sure tests run after installPhase.
  doInstallCheck = true;
  installCheckTarget = "check";
  doCheck = false;

  meta = {
    description = "C++ library for arithmetic and algebraic computations";
    mainProgram = "givaro-config";
    license = lib.licenses.cecill-b;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.unix;
  };
}
