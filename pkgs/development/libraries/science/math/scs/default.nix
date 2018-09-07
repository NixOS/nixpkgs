{ stdenv, fetchFromGitHub, blas, liblapack, gfortran }:

stdenv.mkDerivation rec {
  name = "scs-${version}";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "cvxgrp";
    repo = "scs";
    rev = "v${version}";
    sha256 = "17lbcmcsniqlyzgbzmjipfd0rrk25a8hzh7l5wl2wp1iwsd8c3a9";
  };

  buildInputs = [ blas liblapack gfortran.cc.lib ];

  # Actually link and add libgfortran to the rpath
  patchPhase = ''
    sed -i 's/#-lgfortran/-lgfortran/' scs.mk
  '';

  doCheck = true;

  # Test demo requires passing any int as $1; 42 chosen arbitrarily
  checkPhase = ''
    ./out/demo_socp_indirect 42
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp -r include $out/
    cp out/*.a out/*.so $out/lib/
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
