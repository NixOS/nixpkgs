{ stdenv, fetchgit, libpng, libjpeg }:

stdenv.mkDerivation rec {
  name = "farbfeld-${version}";
  version = "3";

  src = fetchgit {
    url = "http://git.suckless.org/farbfeld";
    rev = "refs/tags/${version}";
    sha256 = "1k9cnw2zk9ywcn4hibf7wgi4czwyxhgjdmia6ghpw3wcz8vi71xl";
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
