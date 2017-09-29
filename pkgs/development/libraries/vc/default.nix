{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "Vc-${version}";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "VcDevel";
    repo = "Vc";
    rev = version;
    sha256 = "119sm0kldr5j163ff04fra35420cvpj040hs7n0mnfbcgyx4nxq9";
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
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ abbradar ];
  };
}
