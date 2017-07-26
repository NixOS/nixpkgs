{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "poppler-data-0.4.7";

  src = fetchurl {
    url = "http://poppler.freedesktop.org/${name}.tar.gz";
    sha256 = "1pm7wg6xqj4sppb5az4pa7psfdk4yxxkw52j85bm9fksibcb0lp7";
  };

  postPatch = ''
    sed -i 's,$(datadir)/pkgconfig,$(prefix)/lib/pkgconfig,g' Makefile
  '';

  installFlags = [ "prefix=$(out)" ];

  meta = with stdenv.lib; {
    homepage = http://poppler.freedesktop.org/;
    description = "Encoding files for Poppler, a PDF rendering library";
    platforms = platforms.all;
    license = licenses.free; # more free licenses combined
    maintainers = with maintainers; [ ];
  };
}
