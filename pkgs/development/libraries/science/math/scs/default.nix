{ stdenv, fetchFromGitHub, blas, liblapack, gfortran, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  name = "scs-${version}";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "cvxgrp";
    repo = "scs";
    rev = "v${version}";
    sha256 = "17lbcmcsniqlyzgbzmjipfd0rrk25a8hzh7l5wl2wp1iwsd8c3a9";
  };

  # Actually link and add libgfortran to the rpath
  postPatch = ''
    substituteInPlace scs.mk \
      --replace "#-lgfortran" "-lgfortran" \
      --replace "gcc" "cc"
  '';

  nativeBuildInputs = stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames;

  buildInputs = [ blas liblapack gfortran.cc.lib ];

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
    homepage = https://github.com/cvxgrp/scs;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.bhipple ];
  };
}
