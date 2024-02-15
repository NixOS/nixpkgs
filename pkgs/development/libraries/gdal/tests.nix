{ runCommand, gdal, jdk }:

let
  inherit (gdal) pname version;

in
runCommand "${pname}-tests" { meta.timeout = 60; }
  ''
    # test version
    ${gdal}/bin/ogrinfo --version \
      | grep 'GDAL ${version}'

    ${gdal}/bin/gdalinfo --version \
      | grep 'GDAL ${version}'


    # test formats
    ${gdal}/bin/ogrinfo --formats \
      | grep 'GPKG.*GeoPackage'

    ${gdal}/bin/gdalinfo --formats \
      | grep 'GTiff.*GeoTIFF'


    # test vector file
    echo -e "Latitude,Longitude,Name\n48.1,0.25,'Test point'" > test.csv
    ${gdal}/bin/ogrinfo ./test.csv


    # test raster file
    ${gdal}/bin/gdal_create \
      -a_srs "EPSG:4326" \
      -of GTiff \
      -ot UInt16 \
      -a_nodata 255 \
      -burn 0 \
      -outsize 800 600 \
      -co COMPRESS=LZW \
      test.tif

    ${gdal}/bin/gdalinfo ./test.tif

    # test java bindings
    cat <<EOF > main.java
    import org.gdal.gdal.gdal;
    class Main {
      public static void main(String[] args) {
      gdal.AllRegister();
      }
    }
    EOF
    ${jdk}/bin/java -Djava.library.path=${gdal}/lib/ -cp ${gdal}/share/java/gdal-${version}.jar main.java

    touch $out
  ''
