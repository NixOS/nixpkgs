{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyprobables";
  version = "0.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "barrust";
    repo = "pyprobables";
    tag = "v${version}";
    hash = "sha256-CxxpiYtqoAm81YjL6nTFIk4MnBG+1n3wbnW8u29lQlw=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "probables" ];

  meta = with lib; {
    description = "Probabilistic data structures";
    homepage = "https://github.com/barrust/pyprobables";
    changelog = "https://github.com/barrust/pyprobables/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
