{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mac-alias,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ds-store";
  version = "1.3.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "al45tair";
    repo = "ds_store";
    rev = "refs/tags/v${version}";
    hash = "sha256-45lmkE61uXVCBUMyVVzowTJoALY1m9JI68s7Yb0vCks=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ mac-alias ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ds_store" ];

  meta = with lib; {
    homepage = "https://github.com/al45tair/ds_store";
    description = "Manipulate Finder .DS_Store files from Python";
    mainProgram = "ds_store";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
