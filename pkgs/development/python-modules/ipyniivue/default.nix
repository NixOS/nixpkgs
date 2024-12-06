{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchNpmDeps,
  pythonOlder,
  nodejs,
  npmHooks,
  hatchling,
  hatch-vcs,
  anywidget,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ipyniivue";
  version = "2.0.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "niivue";
    repo = "ipyniivue";
    rev = "v${version}";
    hash = "sha256-6DZmHVVxJspjUhJ9pzTmTvwAnQfvTp8OL2xZONz2XbU=";
  };

  npmDeps = fetchNpmDeps {
    name = "${pname}-${version}-npm-deps";
    inherit src;
    hash = "sha256-ZJRBGMNn5clxMavimfl6Jwqf7M2pRo+WLne0gUWOiJ8=";
  };

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
  ];

  dependencies = [ anywidget ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "ipyniivue" ];

  meta = with lib; {
    description = "Show a nifti image in a webgl 2.0 canvas within a jupyter notebook cell";
    homepage = "https://github.com/niivue/ipyniivue";
    changelog = "https://github.com/niivue/ipyniivue/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
