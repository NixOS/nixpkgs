{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "Vc";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "VcDevel";
    repo = "Vc";
    rev = version;
    sha256 = "sha256-tbHDGbul68blBAvok17oz7AfhHpEY9Y7RIEsqCQvOJ0=";
  };

  nativeBuildInputs = [ cmake ];

  postPatch = ''
    sed -i '/OptimizeForArchitecture()/d' cmake/VcMacros.cmake
    sed -i '/AutodetectHostArchitecture()/d' print_target_architecture.cmake
  '';

  meta = with lib; {
    description = "Library for multiprecision complex arithmetic with exact rounding";
    homepage = "https://github.com/VcDevel/Vc";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ abbradar ];
  };
}
