{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "elm-review";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "jfmengels";
    repo = "node-elm-review";
    rev = "v${version}";
    hash = "sha256-+RF1D1gTsZlxE+Pe29T11TT6bWkt17bX7MX0YjBUPcI=";
  };

  npmDepsHash = "sha256-suNOrGhHoAopBnIar8+HNUk4xwDtFq1gj3GvN2tD5l0=";

  postPatch = ''
    sed -i "s/elm-tooling install/echo 'skipping elm-tooling install'/g" package.json
  '';

  dontNpmBuild = true;

  meta = {
    changelog = "https://github.com/jfmengels/node-elm-review/blob/v${src.rev}/CHANGELOG.md";
    description = "Analyzes Elm projects, to help find mistakes before your users find them";
    mainProgram = "elm-review";
    homepage = "https://github.com/jfmengels/node-elm-review";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      turbomack
      zupo
    ];
  };
}
