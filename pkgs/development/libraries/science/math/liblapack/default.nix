{ lib
, stdenv
, fetchFromGitHub
, gfortran
, cmake
, shared ? true
# Compile with ILP64 interface
, blas64 ? false
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "liblapack";
  version = "3.12.0";

  src = fetchFromGitHub {
    owner = "Reference-LAPACK";
    repo = "lapack";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-xn9HL4YF8JPka1gwet5bGGo2k505H3RfWpxkUIYNecQ=";
  };

  nativeBuildInputs = [ gfortran cmake ];

  # Configure stage fails on aarch64-darwin otherwise, due to either clang 11 or gfortran 10.
  hardeningDisable = lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [ "stackprotector" ];

  cmakeFlags = [
    "-DCMAKE_Fortran_FLAGS=-fPIC"
    "-DLAPACKE=ON"
    "-DCBLAS=ON"
    "-DBUILD_TESTING=ON"
  ] ++ lib.optional shared "-DBUILD_SHARED_LIBS=ON"
    ++ lib.optional blas64 "-DBUILD_INDEX64=ON"
    # Tries to run host platform binaries during the build
    # Will likely be disabled by default in 3.12, see:
    # https://github.com/Reference-LAPACK/lapack/issues/757
    ++ lib.optional (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) "-DTEST_FORTRAN_COMPILER=OFF";

  passthru = { inherit blas64; };

  postInstall =  let
    canonicalExtension = if stdenv.hostPlatform.isLinux
                       then "${stdenv.hostPlatform.extensions.sharedLibrary}.${lib.versions.major finalAttrs.version}"
                       else stdenv.hostPlatform.extensions.sharedLibrary;
  in lib.optionalString blas64 ''
    ln -s $out/lib/liblapack64${canonicalExtension} $out/lib/liblapack${canonicalExtension}
    ln -s $out/lib/liblapacke64${canonicalExtension} $out/lib/liblapacke${canonicalExtension}
  '';

  doCheck = true;

  # Some CBLAS related tests fail on Darwin:
  #  14 - CBLAS-xscblat2 (Failed)
  #  15 - CBLAS-xscblat3 (Failed)
  #  17 - CBLAS-xdcblat2 (Failed)
  #  18 - CBLAS-xdcblat3 (Failed)
  #  20 - CBLAS-xccblat2 (Failed)
  #  21 - CBLAS-xccblat3 (Failed)
  #  23 - CBLAS-xzcblat2 (Failed)
  #  24 - CBLAS-xzcblat3 (Failed)
  #
  # Upstream issue to track:
  # * https://github.com/Reference-LAPACK/lapack/issues/440
  ctestArgs = lib.optionalString stdenv.isDarwin "-E '^(CBLAS-(x[sdcz]cblat[23]))$'";

  checkPhase = ''
    runHook preCheck
    ctest ${finalAttrs.ctestArgs}
    runHook postCheck
  '';

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    description = "Linear Algebra PACKage";
    homepage = "http://www.netlib.org/lapack/";
    maintainers = with maintainers; [ markuskowa ];
    license = licenses.bsd3;
    pkgConfigModules = [ "lapack" ];
    platforms = platforms.all;
  };
})
