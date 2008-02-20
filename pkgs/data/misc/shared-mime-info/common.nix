hash: args: with args;

stdenv.mkDerivation rec {
  name = "shared-mime-info-" + version;

  src = fetchurl {
    url = "http://freedesktop.org/~hadess/${name}.tar.bz2";
    sha256 = hash;
  };

  buildInputs = [perl perlXMLParser pkgconfig gettext libxml2 glib];

  meta = {
    homepage = http://freedesktop.org/wiki/Software/shared-mime-info;
  };
}
