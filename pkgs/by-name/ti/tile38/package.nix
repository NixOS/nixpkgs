{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tile38";
  version = "1.36.2";

  src = fetchFromGitHub {
    owner = "tidwall";
    repo = "tile38";
    tag = version;
    hash = "sha256-VUNDVZT3ENsVHj+ZMOAXgbZTGMdmo0TCXN/ecpN2Xs8=";
  };

  vendorHash = "sha256-YiivAh7aXeVuvI9V1ayvqjJ658Hu8/1icvRbqq2QeI0=";

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
