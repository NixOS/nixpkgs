{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "tile38";
  version = "1.37.0";

  src = fetchFromGitHub {
    owner = "tidwall";
    repo = "tile38";
    tag = finalAttrs.version;
    hash = "sha256-5dnLeXqEo89m2LFAbDw/NelSJpxGFYWQlIcw8PY2/RA=";
  };

  vendorHash = "sha256-mi4Cz3nb/5qbC9sp2o5FptBDh2AdxTOk3hWBpVr9K3s=";

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
