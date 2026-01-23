{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  toml,
  pyyaml,
  packvers,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dparse2";
  version = "0.7.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "nexB";
    repo = "dparse2";
    tag = version;
    hash = "sha256-JUTL+SVf1RRIXQqwFR7MnExsgGseSiO0a5YzzcqdXHw=";
  };

  propagatedBuildInputs = [
    toml
    pyyaml
    packvers
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # Requires pipenv
    "tests/test_parse.py"
  ];

  pythonImportsCheck = [ "dparse2" ];

  meta = {
    description = "Module to parse Python dependency files";
    homepage = "https://github.com/nexB/dparse2";
    changelog = "https://github.com/nexB/dparse2/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
