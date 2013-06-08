{ stdenv, fetchurl, zlib, libpng, patchutils }:

stdenv.mkDerivation {
  name = "libharu-2.2.1";

  src = fetchurl {
    url = http://libharu.org/files/libharu-2.2.1.tar.bz2;
    sha256 = "04493rjb4z8f04p3kjvnya8phg4b0vzy3mbdbp8jfy0dhvqg4h4j";
  };

  configureFlags = "--with-zlib=${zlib} --with-png=${libpng}";

  buildInputs = [ zlib libpng ];

  patches =
    [ (stdenv.mkDerivation {
        name = "linpng15.patch";

        src = fetchurl {
          url = https://github.com/tony2001/libharu/commit/e5bf8b01f6c3d5e3fe0e26ac5345e0da10c03934.diff;
          sha256 = "1993vskpycyr43rwdp8f688fc5zvllrqq935r7rhsgbqbipkk73h";
        };

        nativeBuildInputs = [ patchutils ];

        buildCommand = "filterdiff -x '*/CHANGES' $src > $out";
      })
      (fetchurl {
        url = https://github.com/tony2001/libharu/commit/b472b64ab44d834eb29d237f31bf12396fee9aca.diff;
        name = "endless-loop.patch";
        sha256 = "1c95mn6a5wddznqgrsaf3xsh27lz8q0pzc0a7ampxpscq0w6c9fq";
      })
    ];

  meta = {
    description = "Cross platform, open source library for generating PDF files";
    homepage = http://libharu.org/wiki/Main_Page;
    license = "ZLIB/LIBPNG"; # see README.
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
