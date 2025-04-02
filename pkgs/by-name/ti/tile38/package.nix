{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tile38";
  version = "1.34.2";

  src = fetchFromGitHub {
    owner = "tidwall";
    repo = pname;
    rev = version;
    hash = "sha256-F6mSIKivRkqbuixWyl9EmUskHsiQyzNrEt1ONvDVKrg=";
  };

  vendorHash = "sha256-SJ80FSoG8RhsReDmSX120bxzcgZ3cD3vNvWt/HiV3/w=";

  subPackages = [
    "cmd/tile38-cli"
    "cmd/tile38-server"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/tidwall/tile38/core.Version=${version}"
  ];

  meta = with lib; {
    description = "Real-time Geospatial and Geofencing";
    longDescription = ''
      Tile38 is an in-memory geolocation data store, spatial index, and realtime geofence.
      It supports a variety of object types including lat/lon points, bounding boxes, XYZ tiles, Geohashes, and GeoJSON.
    '';
    homepage = "https://tile38.com/";
    license = licenses.mit;
    maintainers = teams.geospatial.members;
  };
}
