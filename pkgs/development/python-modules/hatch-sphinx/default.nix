{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  sphinx,
  pytestCheckHook,
  build,
}:

let
  version = "0.0.4";
in
buildPythonPackage {
  pname = "hatch-sphinx";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "llimeht";
    repo = "hatch-sphinx";
    tag = "v${version}";
    hash = "sha256-8g0UkDMf05CVd2VbnV30pZpQ9chJhCkKfci7zmcIOoQ=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [ sphinx ];

  nativeCheckInputs = [
    pytestCheckHook
    build
  ];

  pythonImportsCheck = [ "hatch_sphinx" ];

  meta = {
    description = "Hatchling build plugin for Sphinx documentation";
    homepage = "https://github.com/llimeht/hatch-sphinx";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kyehn ];
  };
}
