{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "Vc-${version}";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "VcDevel";
    repo = "Vc";
    rev = version;
    sha256 = "1jwwp3g8pqngdakqy3dxy3vgzh0gla5wvwqqlfvqdgsw6455xhm7";
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
