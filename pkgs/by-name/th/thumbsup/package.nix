{ buildNpmPackage
, fetchFromGitHub
, lib
, nodejs
, imagemagick
, graphicsmagick
, exiftool
}:

buildNpmPackage rec {
  pname = "thumbsup";
  version = "2.18.0";

  src = fetchFromGitHub {
    owner = "thumbsup";
    repo = "thumbsup";
    rev = "v${version}";
    hash = "sha256-q3zeIdGGrv9thJiTjaNFbq3bTEq2i91KR6yXIzHLQ24=";
  };

  npmDepsHash = "sha256-dyA0cmO6yCn5ZFhTEQXTuQyr8UrrW6WasrA9kqqUlC8=";

  buildInputs = [
    nodejs
    imagemagick
    graphicsmagick
    exiftool
  ];

  dontNpmBuild = true;

  meta = with lib; {
    description = "Static web galleries for all your photos and videos";
    homepage = "https://thumbsup.github.io/";
    changelog = "https://github.com/thumbsup/thumbsup/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "thumbsup";
    maintainers = [ maintainers.presto8 ];
  };
}
