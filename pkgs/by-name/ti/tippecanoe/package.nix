{
  lib,
  stdenv,
  fetchFromGitHub,
  sqlite,
  zlib,
  perl,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tippecanoe";
  version = "2.79.0";

  src = fetchFromGitHub {
    owner = "felt";
    repo = "tippecanoe";
    tag = finalAttrs.version;
    hash = "sha256-oEGjeOJWOV7ZO6GjpzC+rbvxyKDm7w64NQ6m43Wa30k=";
  };

  buildInputs = [
    sqlite
    zlib
  ];
  nativeCheckInputs = [ perl ];

  makeFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  # https://github.com/felt/tippecanoe/issues/148
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = "v${finalAttrs.version}";
  };

  meta = {
    description = "Build vector tilesets from large collections of GeoJSON features";
    homepage = "https://github.com/felt/tippecanoe";
    license = lib.licenses.bsd2;
    teams = [ lib.teams.geospatial ];
    platforms = lib.platforms.unix;
    mainProgram = "tippecanoe";
  };
})
