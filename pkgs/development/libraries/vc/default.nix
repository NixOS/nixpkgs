{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "Vc-${version}";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "VcDevel";
    repo = "Vc";
    rev = version;
    sha256 = "09nf6j1hyq2yv0c1cmnv4ff5243ylsajy1xj3dz8c2qqcm14y6cm";
  };

  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  postPatch = ''
    sed -i '/OptimizeForArchitecture()/d' cmake/VcMacros.cmake
    sed -i '/AutodetectHostArchitecture()/d' print_target_architecture.cmake
  '';

  meta = with stdenv.lib; {
    description = "Library for multiprecision complex arithmetic with exact rounding";
    homepage = https://github.com/VcDevel/Vc;
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ abbradar ];
  };
}
