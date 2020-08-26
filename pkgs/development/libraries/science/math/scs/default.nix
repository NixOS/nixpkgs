{ stdenv, fetchFromGitHub, blas, lapack, gfortran, fixDarwinDylibNames }:

assert (!blas.isILP64) && (!lapack.isILP64);

stdenv.mkDerivation rec {
  pname = "scs";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "cvxgrp";
    repo = "scs";
    rev = version;
    sha256 = "14g5m3lcvrbwpq1bq0liq00jh0gm1947lg3z4jfsp43f6p5alb20";
  };

  # Actually link and add libgfortran to the rpath
  postPatch = ''
    substituteInPlace scs.mk \
      --replace "#-lgfortran" "-lgfortran" \
      --replace "gcc" "cc"
  '';

  nativeBuildInputs = stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames;

  buildInputs = [ blas lapack gfortran.cc.lib ];

  doCheck = true;

  # Test demo requires passing data and seed; numbers chosen arbitrarily.
  postCheck = ''
    ./out/demo_socp_indirect 42 0.42 0.42 42
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib
    cp -r include $out/
    cp out/*.a out/*.so out/*.dylib $out/lib/
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Splitting Conic Solver";
    longDescription = ''
      Numerical optimization package for solving large-scale convex cone problems
    '';
    homepage = "https://github.com/cvxgrp/scs";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.bhipple ];
  };
}
