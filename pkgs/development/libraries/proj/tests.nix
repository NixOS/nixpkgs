{ runCommand, proj }:

let
  inherit (proj) pname;
in
runCommand "${pname}-tests" { meta.timeout = 60; }
  ''
    ${proj}/bin/projinfo EPSG:4326 \
      | grep '+proj=longlat +datum=WGS84 +no_defs +type=crs'
    touch $out
  ''
