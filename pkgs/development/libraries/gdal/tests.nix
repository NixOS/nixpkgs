{ runCommand, gdal }:

let
  inherit (gdal) pname version;

in
runCommand "${pname}-tests" {
  nativeBuildInputs = [ gdal ];
  meta.timeout = 60;
} ''
    # test version
    ogrinfo --version \
      | grep 'GDAL ${version}'

    gdalinfo --version \
      | grep 'GDAL ${version}'


    # test formats
    ogrinfo --formats \
      | grep 'GPKG.*GeoPackage'

    gdalinfo --formats \
      | grep 'GTiff.*GeoTIFF'


    # test vector file
    echo -e "Latitude,Longitude,Name\n48.1,0.25,'Test point'" > test.csv
    ogrinfo ./test.csv


    # test raster file
    gdal_create \
      -a_srs "EPSG:4326" \
      -of GTiff \
      -ot UInt16 \
      -a_nodata 255 \
      -burn 0 \
      -outsize 800 600 \
      -co COMPRESS=LZW \
      test.tif

    gdalinfo ./test.tif

    touch $out
  ''
