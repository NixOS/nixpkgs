{ lib, stdenv, fetchFromGitHub, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  pname = "gumbo";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "gumbo-parser";
    rev = "v${version}";
    sha256 = "0xslckwdh2i0g2qjsb6rnm8mjmbagvziz0hjlf7d1lbljfms1iw1";
  };

  strictDeps = true;
  nativeBuildInputs = [ autoconf automake libtool ];

  preConfigure = "./autogen.sh";

  meta = with lib; {
    description = "C99 HTML parsing algorithm";
    homepage = "https://github.com/google/gumbo-parser";
    maintainers = [ maintainers.nico202 ];
    platforms = with platforms; linux ++ darwin;
    license = licenses.asl20;
  };
}
