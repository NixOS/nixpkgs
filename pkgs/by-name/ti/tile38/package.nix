{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tile38";
  version = "1.33.4";

  src = fetchFromGitHub {
    owner = "tidwall";
    repo = pname;
    rev = version;
    hash = "sha256-8Qu1tuNAqO/XFcfSJ0fXMWFY4UhViV3CFsfAZ2zUsxE=";
  };

  vendorHash = "sha256-nnamNwowRPWQBKUMg800bFgijv8iHbdh/wUwTfX0NcY=";

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
