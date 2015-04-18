{ fetchFromGitHub, stdenv, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  name = "dotconf-" + version;
  version = "1.3";

  src = fetchFromGitHub {
    owner = "williamh";
    repo = "dotconf";
    rev = "v${version}";
    sha256 = "1sc95hw5k2xagpafny0v35filmcn05k1ds5ghkldfpf6xw4hakp7";
  };

  buildInputs = [ autoconf automake libtool ];

  preConfigure = "autoreconf --install";

  meta = with stdenv.lib; {
    description = "A configuration parser library";
    maintainers = with maintainers; [ pSub ];
    homepage = http://www.azzit.de/dotconf/;
    license = licenses.lgpl21Plus;
  };
}
