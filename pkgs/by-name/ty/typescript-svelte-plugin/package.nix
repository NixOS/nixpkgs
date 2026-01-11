{
  lib,
  buildNpmPackage,
  fetchurl,
}:

buildNpmPackage rec {
  pname = "typescript-svelte-plugin";
  version = "0.3.50";

  src = fetchurl {
    url = "https://registry.npmjs.org/typescript-svelte-plugin/-/typescript-svelte-plugin-${version}.tgz";
    hash = "sha256-aQc9raz3wJmVuf9Fcki3wZerxdnUfU4Borc/KeGBzmM=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-ojwxXkTfgQpSjnB2qlBtpTETRI3m8N/heDqsFLO/Wi4=";

  dontNpmBuild = true;

  meta = {
    description = "TypeScript plugin providing Svelte intellisense";
    homepage = "https://github.com/sveltejs/language-tools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ryoppippi ];
    mainProgram = "typescript-svelte-plugin";
  };
}
