{ stdenv, fetchFromGitHub, cmake }:
stdenv.mkDerivation rec {
  pname = "cereal";
  version = "1.2.2";

  nativeBuildInputs = [ cmake ];

  src = fetchFromGitHub {
    owner = "USCiLab";
    repo = "cereal";
    rev = "v${version}";
    sha256 = "1ckr8r03ggg5pyzg8yw40d5ssq40h5najvyqlnxc85fxxp8rnrx4";
  };

  cmakeFlagsArray = [ "-DJUST_INSTALL_CEREAL=yes" ];

  meta = with stdenv.lib; {
    description = "A header-only C++11 serialization library";
    homepage    = https://uscilab.github.io/cereal/;
    platforms   = platforms.all;
    license     = licenses.mit;
  };
}
