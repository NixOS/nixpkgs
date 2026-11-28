{
  stdenv,
  nix-update-script,
  lib,
  nixosTests,
  fetchFromGitHub,
  npm-lockfile-fix,
  buildNpmPackage,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wiki-js_3";
  version = "3.6.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "requarks";
    repo = "wiki";
    rev = finalAttrs.version;
    hash = "sha256-6FUOG53t1Q18fCNCLg7vBrhBop44ypC5sOzPAcIQ+Cs=";

    postFetch = ''
      ${lib.getExe npm-lockfile-fix} -r $out/frontend/package-lock.json
    '';
  };

  frontend = buildNpmPackage {
    inherit (finalAttrs) version src;
    pname = "${finalAttrs.pname}-frontend";
    sourceRoot = "${finalAttrs.src.name}/frontend";
    npmDepsHash = "sha256-+l8UgBaRgs4p26HXDNClX4t5P1jEBZWLR+ofXVF3LYA=";

    dontNpmInstall = true;

    preBuild = ''
      npm pkg set version="$version"
      substituteInPlace vite.config.js \
        --replace-fail "../assets" "${placeholder "out"}/assets"
    '';
  };

  blocks = buildNpmPackage {
    inherit (finalAttrs) version src;
    pname = "${finalAttrs.pname}-blocks";
    sourceRoot = "${finalAttrs.src.name}/blocks";
    npmDepsHash = "sha256-0aBGfzuWBuLcVC5bvx7pJzPMpxH5DvS3Gdm69JHZBoo=";

    dontNpmInstall = true;
    npmBuildFlags = [
      "--"
      "-d"
      "${placeholder "out"}/blocks/compiled"
    ];
  };

  backend = buildNpmPackage {
    inherit (finalAttrs) version src;
    pname = "${finalAttrs.pname}-backend";
    sourceRoot = "${finalAttrs.src.name}/backend";
    npmDepsHash = "sha256-lvHbAMLWuGQSEAw0pxP1Xs7niFkeq0iEbGQxEAbXkMA=";

    dontNpmBuild = true;

    preBuild = ''
      npm pkg set version="$version"
    '';
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/blocks
    cp -r ${finalAttrs.frontend}/assets $out/assets
    cp -r ${finalAttrs.blocks}/blocks/compiled $out/blocks/compiled
    cp -r ${finalAttrs.backend}/lib/node_modules/wiki-backend/ $out/backend/
    cp config.sample.yml $out/config.sample.yml

    runHook postInstall
  '';

  passthru = {
    tests = { inherit (nixosTests.wiki-js) v3; };
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://js.wiki/";
    description = "Modern and powerful wiki app built on Node.js";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      minosimo
      Merded
    ];
  };
})
