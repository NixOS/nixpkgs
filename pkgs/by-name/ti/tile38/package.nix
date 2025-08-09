{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tile38";
  version = "1.35.0";

  src = fetchFromGitHub {
    owner = "tidwall";
    repo = "tile38";
    tag = version;
    hash = "sha256-n17W/JOtVV6Mjhp81xx25j6GUbR9WCd3JLh9voyMeC0=";
  };

  vendorHash = "sha256-/EgUacA9xTUw3e8208NWxhaeZ/KgHLSnxy/fIqC+gZE=";

  subPackages = [
    "cmd/tile38-cli"
    "cmd/tile38-server"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/tidwall/tile38/core.Version=${version}"
  ];

  meta = {
    description = "Real-time Geospatial and Geofencing";
    longDescription = ''
      Tile38 is an in-memory geolocation data store, spatial index, and realtime geofence.
      It supports a variety of object types including lat/lon points, bounding boxes, XYZ tiles, Geohashes, and GeoJSON.
    '';
    homepage = "https://tile38.com/";
    license = lib.licenses.mit;
    teams = [ lib.teams.geospatial ];
  };
}
