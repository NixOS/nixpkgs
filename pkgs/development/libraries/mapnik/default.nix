{ stdenv, fetchzip
, boost, cairo, freetype, gdal, harfbuzz, icu, libjpeg, libpng, libtiff
, libwebp, libxml2, proj, python, scons, sqlite, zlib
}:

stdenv.mkDerivation rec {
  name = "mapnik-${version}";
  version = "3.0.12";

  src = fetchzip {
    # this one contains all git submodules and is cheaper than fetchgit
    url = "https://github.com/mapnik/mapnik/releases/download/v${version}/mapnik-v${version}.tar.bz2";
    sha256 = "02w360fxk0pfkk0zbwc134jq7rkkib58scs5k67j8np6fx6gag6i";
  };

  # a distinct dev output makes python-mapnik fail
  outputs = [ "out" ];

  nativeBuildInputs = [ python scons ];

  buildInputs =
    [ boost cairo freetype gdal harfbuzz icu libjpeg libpng libtiff
      libwebp libxml2 proj python sqlite zlib
    ];

  configurePhase = ''
    scons configure PREFIX="$out"
  '';

  buildPhase = false;

  installPhase = ''
    mkdir -p "$out"
    scons install
  '';

  meta = with stdenv.lib; {
    description = "An open source toolkit for developing mapping applications";
    homepage = http://mapnik.org;
    maintainers = with maintainers; [ hrdinka ];
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
