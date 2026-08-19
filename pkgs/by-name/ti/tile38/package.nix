{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "tile38";
  version = "1.38.0";

  src = fetchFromGitHub {
    owner = "tidwall";
    repo = "tile38";
    tag = finalAttrs.version;
    hash = "sha256-jmUvsSOA16tGp1nAam8ae3cqHU6K2Lfiukfj16N3Hy0=";
  };

  vendorHash = "sha256-zSH5/AQFS73YJpy7kVxHXTF4kPuaxVl4aNdKUq1aqDM=";

  subPackages = [
    "cmd/tile38-cli"
    "cmd/tile38-server"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/tidwall/tile38/core.Version=${finalAttrs.version}"
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
})
