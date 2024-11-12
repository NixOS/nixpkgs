{ runCommand, geos }:

let
  inherit (geos) pname;
in
runCommand "${pname}-tests" { meta.timeout = 60; }
  ''
    ${geos}/bin/geosop \
      --explode \
      --format wkt \
      polygonize \
      -a "MULTILINESTRING ((200 100, 100 100, 200 200), (200 200, 200 100), (200 200, 300 100, 200 100))" \
      | grep 'POLYGON ((200 100, 100 100, 200 200, 200 100))'
    touch $out
  ''
