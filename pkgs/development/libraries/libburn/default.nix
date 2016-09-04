{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libburn-${version}";
  version = "1.4.4";

  src = fetchurl {
    url = "http://files.libburnia-project.org/releases/${name}.tar.gz";
    sha256 = "053x1sj6r5pj5396g007v6l0s7942cy2mh5fd3caqx0jdw6h9xqv";
  };

  meta = with stdenv.lib; {
    homepage = http://libburnia-project.org/;
    description = "A library by which preformatted data get onto optical media: CD, DVD, BD (Blu-Ray)";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ abbradar vrthra ];
    platforms = with platforms; unix;
  };
}
