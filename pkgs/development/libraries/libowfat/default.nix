{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libowfat-0.32";

  src = fetchurl {
    url = "https://www.fefe.de/libowfat/${name}.tar.xz";
    sha256 = "1hcqg7pvy093bxx8wk7i4gvbmgnxz2grxpyy7b4mphidjbcv7fgl";
  };

  # Dirty patch because 0.32 "moved headers to <libowfat/> upon install"
  # but it breaks gatling-0.15 and opentracker-2018-05-26 ...
  postPatch = ''
    substituteInPlace GNUmakefile --replace \
      'install -d $(DESTDIR)$(INCLUDEDIR)/libowfat' \
      'install -d $(DESTDIR)$(INCLUDEDIR)'
    substituteInPlace GNUmakefile --replace \
      'install -m 644 $(INCLUDES) $(DESTDIR)$(INCLUDEDIR)/libowfat' \
      'install -m 644 $(INCLUDES) $(DESTDIR)$(INCLUDEDIR)'
  '';

  makeFlags = [ "prefix=$(out)" ];
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A GPL reimplementation of libdjb";
    homepage = https://www.fefe.de/libowfat/;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
