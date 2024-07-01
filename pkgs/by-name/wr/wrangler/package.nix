{
  lib,
  buildNpmPackage,
  fetchurl,
}:

buildNpmPackage rec {
  pname = "wranger";
  version = "3.60.3";

  src = fetchurl {
    url = "https://registry.npmjs.org/wrangler/-/wrangler-${version}.tgz";
    hash = "a6zn/KFnYaYp3nxJR/aP0TeaBvJDkrrfI89KoxUtx28H7zpya/5/VLu3CxQ3PRspEojJGF0s6f3/pddRy3F+BQ==";
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
