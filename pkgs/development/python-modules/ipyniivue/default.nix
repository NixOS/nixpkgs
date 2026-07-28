{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchNpmDeps,
  nodejs,
  npmHooks,
  hatchling,
  hatch-vcs,
  hatch-jupyter-builder,
  anywidget,
  numpy,
  requests,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "ipyniivue";
  version = "2.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "niivue";
    repo = "ipyniivue";
    tag = "v${version}";
    hash = "sha256-Jk8Os8g2W5IRqLQSLQeH59ffGgWK/gjuUZgUl+HflVA=";
  };

  npmDeps = fetchNpmDeps {
    name = "${pname}-${version}-npm-deps";
    inherit src;
    hash = "sha256-6TbwAC175mkyR8EThMalWn7qEyaIFDxtKmC/RIuy1dk=";
    postPatch = ''
      cp ${./package-lock.json} ./package-lock.json
    '';
  };
  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  # We do not need the build hooks, because we do not need to
  # build any JS components; these are present already in the PyPI artifact.
  env.HATCH_BUILD_NO_HOOKS = true;

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  preBuild = ''
    npm run build
  '';

  build-system = [
    hatchling
    hatch-vcs
    hatch-jupyter-builder
  ];

  dependencies = [
    anywidget
    numpy
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "ipyniivue" ];

  passthru = {
    # https://github.com/niivue/ipyniivue/pull/139
    updateScript = nix-update-script { extraArgs = [ "--generate-lockfile" ]; };
  };

  meta = {
    description = "Show a nifti image in a webgl 2.0 canvas within a jupyter notebook cell";
    homepage = "https://github.com/niivue/ipyniivue";
    changelog = "https://github.com/niivue/ipyniivue/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
