{ stdenv, fetchFromGitHub, cmake }:
stdenv.mkDerivation rec {
  pname = "cereal";
  version = "1.3.0";

  nativeBuildInputs = [ cmake ];

  src = fetchFromGitHub {
    owner = "USCiLab";
    repo = "cereal";
    rev = "v${version}";
    sha256 = "0hc8wh9dwpc1w1zf5lfss4vg5hmgpblqxbrpp1rggicpx9ar831p";
  };

  cmakeFlagsArray = [ "-DJUST_INSTALL_CEREAL=yes" ];

  meta = with stdenv.lib; {
    description = "A header-only C++11 serialization library";
    homepage    = https://uscilab.github.io/cereal/;
    platforms   = platforms.all;
    license     = licenses.mit;
  };
}
