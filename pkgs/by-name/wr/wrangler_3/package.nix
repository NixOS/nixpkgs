{
  lib,
  buildNpmPackage,
  fetchurl,
}:

buildNpmPackage rec {
  pname = "wranger";
  version = "3.62.0";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "workers-sdk";
    rev = "${pname}@${version}";
    hash = "sha256-x/USGgWXn7aJtkMekfTf/zaGBguOZxxPtq29wo2yBq8=";
  };

  npmDepsHash = "sha256-wYrLN42If6gAjRok0tAdVvVoDmv5oK/vvPoT3BxtgdA=";

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Command-line interface for all things Cloudflare Workers";
    homepage = "https://github.com/cloudflare/workers-sdk#readme";
    license = "MIT OR Apache-2.0";
    maintainers = with lib.maintainers; [ dezren39 ];
    mainProgram = "wrangler";
  };
}
