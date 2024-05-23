{ pkgs, runCommand, proj }:

let
  inherit (proj) pname;
  projWithData = pkgs.proj.withProjData [ "nz_linz" ];

in
{
  proj-no-data = runCommand "${pname}-no-data-tests" { }
  ''
    ${proj}/bin/projinfo EPSG:4326 \
      | grep '+proj=longlat +datum=WGS84 +no_defs +type=crs'
    touch $out
  '';

  proj-with-data = runCommand "${pname}-with-data-tests" { }
  ''
    set -o pipefail

    # conversion from NZGD1949 to NZGD2000 using proj strings
    echo '173 -41 0' \
      | ${projWithData}/bin/cs2cs --only-best -f %.8f \
        +proj=longlat +ellps=intl +datum=nzgd49 +nadgrids=nz_linz_nzgd2kgrid0005.tif \
        +to +proj=longlat +ellps=GRS80 +towgs84=0,0,0 \
      | grep -E '[0-9\.\-]+*'

    # conversion from NZGD1949 to NZGD2000 using EPSG codes
    echo '-41 173 0' | ${projWithData}/bin/cs2cs --only-best -f %.8f EPSG:4272 EPSG:4167 \
      | grep -E '[0-9\.\-]+*'

    touch $out
  '';
}
