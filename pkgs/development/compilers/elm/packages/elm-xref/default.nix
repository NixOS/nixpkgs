{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  elmPackages,
  fetchpatch,
}:

buildNpmPackage (finalAttrs: {
  pname = "elm-xref";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "zwilias";
    repo = "elm-xref";
    tag = finalAttrs.version;
    hash = "sha256-J58NTSMo2uxpWFnPX+AGHVAqQOiRfgBxYzis/PZp1MA=";
  };

  patches = [
    # Upstream PR:
    # https://github.com/zwilias/elm-xref/pull/17
    (fetchpatch {
      url = "https://github.com/turboMaCk/elm-xref/commit/55ad630c1afc110197a4785bd2a4cd2388a1d160.patch";
      hash = "sha256-67s8gozhkWN8ci/S3OSwnNABdATY7gpBPy7zaZJPamw=";
    })
  ];

  npmDepsHash = "sha256-QH/F0vhva806AL5F3ySMAyfyrLLqCV32WMGTi715X5I=";

  nativeBuildInputs = [
    elmPackages.elm
  ];

  npmFlags = [ "--ignore-scripts" ];

  npmBuildScript = "elm";

  postConfigure =
    (elmPackages.fetchElmDeps {
      elmPackages = import ./elm-srcs.nix;
      elmVersion = elmPackages.elm.version;
      registryDat = ./registry.dat;
    })
    + ''
      ln -sf ${lib.getExe elmPackages.elm} node_modules/.bin/elm
    '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Cross referencing tool for Elm";
    homepage = "https://github.com/zwilias/elm-xref";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    mainProgram = "elm-xref";
  };
})
