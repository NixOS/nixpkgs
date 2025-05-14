{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tile38";
  version = "1.34.4";

  src = fetchFromGitHub {
    owner = "tidwall";
    repo = "tile38";
    tag = version;
    hash = "sha256-TLVFFgT5lxOLhv1RBS09DCcZAozkcHzIBlJSWt1ztB4=";
  };

  vendorHash = "sha256-geXYLeJf/u+8RD7Slr2x+J6zABkWSIfhxKLxZVF/icU=";

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
