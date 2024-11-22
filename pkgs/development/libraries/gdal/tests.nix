{ runCommand, gdal, jdk, lib, testers }:

let
  inherit (gdal) pname version;

in
{
  ogrinfo-version = testers.testVersion {
    package = gdal;
    command = "ogrinfo --version";
  };

  gdalinfo-version = testers.testVersion {
    package = gdal;
    command = "gdalinfo --version";
  };

  ogrinfo-format-geopackage = runCommand "${pname}-ogrinfo-format-geopackage" { } ''
    ${lib.getExe' gdal "ogrinfo"} --formats \
      | grep 'GPKG.*GeoPackage'
    touch $out
  '';

  gdalinfo-format-geotiff = runCommand "${pname}-gdalinfo-format-geotiff" { } ''
    ${lib.getExe' gdal "gdalinfo"} --formats \
      | grep 'GTiff.*GeoTIFF'
    touch $out
  '';

  vector-file = runCommand "${pname}-vector-file" { } ''
    echo -e "Latitude,Longitude,Name\n48.1,0.25,'Test point'" > test.csv
    ${lib.getExe' gdal "ogrinfo"} ./test.csv
    touch $out
  '';

  raster-file = runCommand "${pname}-raster-file" { } ''
    ${lib.getExe' gdal "gdal_create"} \
      -a_srs "EPSG:4326" \
      -of GTiff \
      -ot UInt16 \
      -a_nodata 255 \
      -burn 0 \
      -outsize 800 600 \
      -co COMPRESS=LZW \
      test.tif

    ${lib.getExe' gdal "gdalinfo"} ./test.tif
    touch $out
  '';

  java-bindings = runCommand "${pname}-java-bindings" { } ''
    cat <<EOF > main.java
    import org.gdal.gdal.gdal;
    class Main {
      public static void main(String[] args) {
      gdal.AllRegister();
      }
    }
    EOF
    ${lib.getExe jdk} -Djava.library.path=${gdal}/lib/ -cp ${gdal}/share/java/gdal-${version}.jar main.java
    touch $out
  '';
}
