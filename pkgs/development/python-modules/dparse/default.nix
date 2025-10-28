{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  hatchling,
  packaging,
  tomli,
  pyyaml,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dparse";
  version = "0.6.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pyupio";
    repo = "dparse";
    tag = version;
    hash = "sha256-LnsmJtWLjV3xoSjacfR9sUwPlOjQTRBWirJVtIJSE8A=";
  };

  build-system = [ hatchling ];

  dependencies = [ packaging ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  optional-dependencies = {
    # FIXME pipenv = [ pipenv ];
    conda = [ pyyaml ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.flatten (lib.attrValues optional-dependencies);

  pythonImportsCheck = [ "dparse" ];

  disabledTests = [
    # requires unpackaged dependency pipenv
    "test_update_pipfile"
  ];

  meta = with lib; {
    description = "Parser for Python dependency files";
    homepage = "https://github.com/pyupio/dparse";
    changelog = "https://github.com/pyupio/dparse/blob/${version}/HISTORY.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ thomasdesr ];
  };
}
