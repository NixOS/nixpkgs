{ lib, stdenv, fetchFromGitHub, sqlite, zlib, perl, testers }:

stdenv.mkDerivation (finalAttrs: {
  pname = "tippecanoe";
  version = "2.51.0";

  src = fetchFromGitHub {
    owner = "felt";
    repo = "tippecanoe";
    rev = finalAttrs.version;
    hash = "sha256-5Cu+0Tn+ExxJTO5AjeTnIJtnpBNKR7nxudD77X696H0=";
  };

  buildInputs = [ sqlite zlib ];
  nativeCheckInputs = [ perl ];

  makeFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  # https://github.com/felt/tippecanoe/issues/148
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = "v${finalAttrs.version}";
  };

  meta = with lib; {
    description = "Build vector tilesets from large collections of GeoJSON features";
    homepage = "https://github.com/felt/tippecanoe";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
    mainProgram = "tippecanoe";
  };
})
