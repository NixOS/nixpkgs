{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  elmPackages,
}:

buildNpmPackage (finalAttrs: {
  pname = "elm-doc-preview";
  version = "6.0.1";

  src = fetchFromGitHub {
    owner = "dmy";
    repo = "elm-doc-preview";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nkmNp8oXaGQH8ES69ci+/flhvgtLM/vdiBvOqWA3pZ0=";
  };

  npmDepsHash = "sha256-mGDXhPU2dwTwbJZPi5tUoSMTmzauHBBU1QN2IyZ1YBA=";

  nativeBuildInputs = [
    elmPackages.elm
  ];

  npmRebuildFlags = [ "--ignore-scripts" ];

  npmBuildScript = "prepare";

  postConfigure = (
    elmPackages.fetchElmDeps {
      elmPackages = import ./elm-srcs.nix;
      elmVersion = elmPackages.elm.version;
      registryDat = ./registry.dat;
    }
  );

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Elm offline documentation previewer";
    homepage = "https://github.com/dmy/elm-doc-preview";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
