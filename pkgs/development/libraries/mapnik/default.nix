{ lib, stdenv, fetchzip
, boost, cairo, freetype, gdal, harfbuzz, icu, libjpeg, libpng, libtiff
, libwebp, libxml2, proj, python3, python ? python3, sqlite, zlib
, sconsPackages

# supply a postgresql package to enable the PostGIS input plugin
, postgresql ? null
}:

let
  scons = sconsPackages.scons_3_0_1;
in stdenv.mkDerivation rec {
  pname = "mapnik";
  version = "3.1.0";

  src = fetchzip {
    # this one contains all git submodules and is cheaper than fetchgit
    url = "https://github.com/mapnik/mapnik/releases/download/v${version}/mapnik-v${version}.tar.bz2";
    sha256 = "sha256-qqPqN4vs3ZsqKgnx21yQhX8OzHca/0O+3mvQ/vnC5EY=";
  };

  postPatch = ''
    substituteInPlace configure \
      --replace '$PYTHON scons/scons.py' ${scons}/bin/scons
    rm -r scons
  '';

  # a distinct dev output makes python-mapnik fail
  outputs = [ "out" ];

  nativeBuildInputs = [ scons ];

  buildInputs = [
    boost cairo freetype gdal harfbuzz icu libjpeg libpng libtiff
    libwebp proj python sqlite zlib

    # optional inputs
    postgresql
  ];

  propagatedBuildInputs = [ libxml2 ];

  prefixKey = "PREFIX=";

  preConfigure = ''
    patchShebangs ./configure
  '';

  # NOTE: 2021-05-06:
  # Add -DACCEPT_USE_OF_DEPRECATED_PROJ_API_H=1 for backwards compatibility
  # with major versions 6 and 7 of proj which are otherwise not compatible
  # with mapnik 3.1.0. Note that:
  #
  # 1. Starting with proj version 8, this workaround will no longer be
  #    supported by the upstream proj project.
  #
  # 2. Without the workaround, mapnik configures itself without proj support.
  #
  # 3. The master branch of mapnik (after 3.1.0) appears to add native support
  #    for the proj 6 api, so this workaround is not likely to be needed in
  #    subsequent mapnik releases. At that point, this block comment and the
  #    NIX_CFLAGS_COMPILE expression can be removed.

  NIX_CFLAGS_COMPILE =
    if version != "3.1.0" && lib.versionAtLeast version "3.1.0"
    then throw "The mapnik compatibility workaround for proj 6 may no longer be required. Remove workaround after checking."
    else if lib.versionAtLeast (lib.getVersion proj) "8"
    then throw ("mapnik currently requires a version of proj less than 8, but proj version is: " + (lib.getVersion proj))
    else "-DACCEPT_USE_OF_DEPRECATED_PROJ_API_H=1";

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
    "PROJ_INCLUDES=${proj.dev}/include"
    "PROJ_LIBS=${proj.out}/lib"
    "SQLITE_INCLUDES=${sqlite.dev}/include"
    "SQLITE_LIBS=${sqlite.out}/lib"
    "TIFF_INCLUDES=${libtiff.dev}/include"
    "TIFF_LIBS=${libtiff.out}/lib"
    "WEBP_INCLUDES=${libwebp}/include"
    "WEBP_LIBS=${libwebp}/lib"
    "XMLPARSER=libxml2"
  ];

  buildFlags = [
    "JOBS=$(NIX_BUILD_CORES)"
  ];

  meta = with lib; {
    description = "An open source toolkit for developing mapping applications";
    homepage = "https://mapnik.org";
    maintainers = with maintainers; [ hrdinka erictapen ];
    license = licenses.lgpl21;
    platforms = platforms.all;
    # https://github.com/mapnik/mapnik/issues/4232
    broken = lib.versionAtLeast proj.version "8.0.0";
  };
}
