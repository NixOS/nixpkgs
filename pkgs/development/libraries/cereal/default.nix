{ lib, stdenv, fetchFromGitHub, cmake }:
stdenv.mkDerivation rec {
  pname = "cereal";
  version = "1.3.2";

  nativeBuildInputs = [ cmake ];

  src = fetchFromGitHub {
    owner = "USCiLab";
    repo = "cereal";
    rev = "v${version}";
    hash = "sha256-HapnwM5oSNKuqoKm5x7+i2zt0sny8z8CePwobz1ITQs=";
  };

  cmakeFlags = [ "-DJUST_INSTALL_CEREAL=yes" ];

  meta = with lib; {
    description = "A header-only C++11 serialization library";
    homepage    = "https://uscilab.github.io/cereal/";
    platforms   = platforms.all;
    license     = licenses.mit;
  };
}
