{ stdenv, fetchgit, libpng, libjpeg }:

stdenv.mkDerivation rec {
  name = "farbfeld-${version}";
  version = "2";

  src = fetchgit {
    url = "http://git.suckless.org/farbfeld";
    rev = "refs/tags/${version}";
    sha256 = "1rj6pqn50v6r7l3j7m872fgynxsh22zx863jg0jzmb4x6wx2m2qv";
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
