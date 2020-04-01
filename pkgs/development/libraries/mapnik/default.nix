{ stdenv, fetchzip
, boost, cairo, freetype, gdal, harfbuzz, icu, libjpeg, libpng, libtiff
, libwebp, libxml2, proj, python, sqlite, zlib

# supply a postgresql package to enable the PostGIS input plugin
, postgresql ? null
}:

stdenv.mkDerivation rec {
  pname = "mapnik";
  version = "3.0.23";

  src = fetchzip {
    # this one contains all git submodules and is cheaper than fetchgit
    url = "https://github.com/mapnik/mapnik/releases/download/v${version}/mapnik-v${version}.tar.bz2";
    sha256 = "1754m8y7fyk0dyf7cglhavsk66g5kdqhnmgicib1jkcgjbl69f15";
  };

  # a distinct dev output makes python-mapnik fail
  outputs = [ "out" ];

  nativeBuildInputs = [ python ];

  buildInputs =
    [ boost cairo freetype gdal harfbuzz icu libjpeg libpng libtiff
      libwebp libxml2 proj python sqlite zlib

      # optional inputs
      postgresql
    ];

  prefixKey = "PREFIX=";

  preConfigure = ''
    patchShebangs ./configure
  '';

  configureFlags = [
    "BOOST_INCLUDES=${boost.dev}/include"
    "BOOST_LIBS=${boost.out}/lib"
    "CAIRO_INCLUDES=${cairo.dev}/include"
    "CAIRO_LIBS=${cairo.out}/lib"
    "FREETYPE_INCLUDES=${freetype.dev}/include"
    "FREETYPE_LIBS=${freetype.out}/lib"
    "GDAL_CONFIG=${gdal}/bin/gdal-config"
    "HB_INCLUDES=${harfbuzz.dev}/include"
    "HB_LIBS=${harfbuzz.out}/lib"
    "ICU_INCLUDES=${icu.dev}/include"
    "ICU_LIBS=${icu.out}/lib"
    "JPEG_INCLUDES=${libjpeg.dev}/include"
    "JPEG_LIBS=${libjpeg.out}/lib"
    "PNG_INCLUDES=${libpng.dev}/include"
    "PNG_LIBS=${libpng.out}/lib"
    "PROJ_INCLUDES=${proj}/include"
    "PROJ_LIBS=${proj}/lib"
    "SQLITE_INCLUDES=${sqlite.dev}/include"
    "SQLITE_LIBS=${sqlite.out}/lib"
    "TIFF_INCLUDES=${libtiff.dev}/include"
    "TIFF_LIBS=${libtiff.out}/lib"
    "WEBP_INCLUDES=${libwebp}/include"
    "WEBP_LIBS=${libwebp}/lib"
    "XML2_INCLUDES=${libxml2.dev}/include"
    "XML2_LIBS=${libxml2.out}/lib"
  ];

  meta = with stdenv.lib; {
    description = "An open source toolkit for developing mapping applications";
    homepage = https://mapnik.org;
    maintainers = with maintainers; [ hrdinka ];
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
