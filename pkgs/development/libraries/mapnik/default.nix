{ stdenv, fetchurl
, boost, cairo, freetype, gdal, harfbuzz, icu, libjpeg, libpng, libtiff
, libwebp, libxml2, proj, python, scons, sqlite, zlib
}:

stdenv.mkDerivation rec {
  name = "mapnik-${version}";
  version = "3.0.10";

  src = fetchurl {
    url = "https://mapnik.s3.amazonaws.com/dist/v${version}/mapnik-v${version}.tar.bz2";
    sha256 = "0fda6syrfb81930sf7rgw1qmpnik8k1ngrjkh43ywd3s37nbqh1n";
  };

  outputs = [ "out" "dev" ];

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
