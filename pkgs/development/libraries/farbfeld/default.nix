{ stdenv, fetchgit, libpng, libjpeg }:

stdenv.mkDerivation rec {
  name = "farbfeld-${version}";
  version = "1";

  src = fetchgit {
    url = "http://git.suckless.org/farbfeld";
    rev = "refs/tags/${version}";
    sha256 = "1mgk46lpqqvn4qx37r0jxz2jjsd4nvl6zjl04y4bfyzf4wkkmmln";
  };

  buildInputs = [ libpng libjpeg ];

  installFlags = "PREFIX=/ DESTDIR=$(out)";

  meta = with stdenv.lib; {
    description = "Suckless image format with conversion tools";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
