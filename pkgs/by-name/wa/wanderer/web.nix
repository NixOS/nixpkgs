{
  lib,
  buildNpmPackage,
  makeWrapper,
  nodejs,
  wanderer,

  # Markdown file replacing the "About" section shown to visitors who are not logged in
  aboutFile ? null,
}:

buildNpmPackage {
  pname = "wanderer-web";
  inherit (wanderer) version src;

  sourceRoot = "${wanderer.src.name}/web";

  npmDepsHash = "sha256-b+0dIq0lb6FbSvR/FutHUSU4Rvt72O/ddJ7ltvpOUVI=";
  npmDepsFetcherVersion = 2;

  nativeBuildInputs = [ makeWrapper ];

  postPatch =
    lib.optionalString (aboutFile != null) # bash
      ''
        if [ ! -f static/md/about.md ]; then
          echo "static/md/about.md does not exist anymore, aboutFile needs to be updated" >&2
          exit 1
        fi
        cp ${aboutFile} static/md/about.md
      '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/wanderer-web
    cp -r build package.json node_modules $out/share/wanderer-web/

    makeWrapper ${nodejs}/bin/node $out/bin/wanderer-web \
      --add-flags $out/share/wanderer-web/build/index.js

    runHook postInstall
  '';

  __structuredAttrs = true;

  meta = wanderer.meta // {
    description = "Web frontend of wanderer, a self-hosted trail database";
    mainProgram = "wanderer-web";
  };
}
