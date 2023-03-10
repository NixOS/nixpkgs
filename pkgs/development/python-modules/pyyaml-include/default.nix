{ lib, buildPythonPackage, fetchPypi
, pytestCheckHook
, pyyaml
, setuptools-scm
, setuptools-scm-git-archive
, toml
}:

buildPythonPackage rec {
  pname = "pyyaml-include";
  version = "1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-9/vrjnG1C+Dm4HRy98edv7GhW63pyToHg2n/SeV+Z3E=";
  };

  nativeBuildInputs = [
    pyyaml
    setuptools-scm
    setuptools-scm-git-archive
    toml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "yamlinclude" ];

  meta = with lib; {
    description = "Extending PyYAML with a custom constructor for including YAML files within YAML files";
    homepage = "https://github.com/tanbro/pyyaml-include";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jonringer ];
  };
}
