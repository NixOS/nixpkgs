{ stdenv, fetchgit, libpng, libjpeg }:

stdenv.mkDerivation rec {
  name = "farbfeld-${version}";
  version = "4";

  src = fetchgit {
    url = "https://git.suckless.org/farbfeld";
    rev = "refs/tags/${version}";
    sha256 = "0pkmkvv5ggpzqwqdchd19442x8gh152xy5z1z13ipfznhspsf870";
  };

  buildInputs = [ libpng libjpeg ];

  installFlags = "PREFIX=/ DESTDIR=$(out)";

  meta = with stdenv.lib; {
    description = "Suckless image format with conversion tools";
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
