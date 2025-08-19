{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tile38";
  version = "1.36.0";

  src = fetchFromGitHub {
    owner = "tidwall";
    repo = "tile38";
    tag = version;
    hash = "sha256-FJ1I82ECCit6FV0F5VfY5xa6qCEqZo47KdnY0vwRGzg=";
  };

  vendorHash = "sha256-hpqH/+MlXPz3NZ0ooyWwf1Rg2UeKW49xQ0KbCFIi7jc=";

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
