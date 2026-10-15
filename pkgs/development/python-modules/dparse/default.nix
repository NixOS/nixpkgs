{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  packaging,
  pyyaml,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dparse";
  version = "0.6.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyupio";
    repo = "dparse";
    tag = version;
    hash = "sha256-LnsmJtWLjV3xoSjacfR9sUwPlOjQTRBWirJVtIJSE8A=";
  };

  build-system = [ hatchling ];

  dependencies = [ packaging ];

  optional-dependencies = {
    # FIXME pipenv = [ pipenv ];
    conda = [ pyyaml ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "dparse" ];

  disabledTests = [
    # requires unpackaged dependency pipenv
    "test_update_pipfile"
  ];

  meta = {
    description = "Parser for Python dependency files";
    homepage = "https://github.com/pyupio/dparse";
    changelog = "https://github.com/pyupio/dparse/blob/${version}/HISTORY.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ thomasdesr ];
  };
}
