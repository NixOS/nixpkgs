{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  packaging,
  hypothesis,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "rmscene";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ricklupton";
    repo = "rmscene";
    tag = "v${version}";
    hash = "sha256-AejIkrvNIgUoNtDJwqPvMMToa12dnZQDKWvNztOgAvc=";
  };

  build-system = [
    poetry-core
  ];

  pythonRelaxDeps = [ "packaging" ];

  dependencies = [ packaging ];

  pythonImportsCheck = [ "rmscene" ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/ricklupton/rmscene/blob/${src.tag}/README.md#changelog";
    description = "Read v6 .rm files from the reMarkable tablet";
    homepage = "https://github.com/ricklupton/rmscene";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
