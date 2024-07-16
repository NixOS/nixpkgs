{ lib, stdenv, fetchFromGitHub, sqlite, zlib, perl, versionCheckHook }:

stdenv.mkDerivation (finalAttrs: {
  pname = "tippecanoe";
  version = "2.55.0";

  src = fetchFromGitHub {
    owner = "felt";
    repo = "tippecanoe";
    rev = finalAttrs.version;
    hash = "sha256-hF1tiI5M8BdJoJEZDqC6BkzndmYRQU4jHhjUvYowBTU=";
  };

  buildInputs = [ sqlite zlib ];
  nativeCheckInputs = [ perl ];

  makeFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  # https://github.com/felt/tippecanoe/issues/148
  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = with lib; {
    description = "Build vector tilesets from large collections of GeoJSON features";
    homepage = "https://github.com/felt/tippecanoe";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
    mainProgram = "tippecanoe";
  };
})
