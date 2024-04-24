{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, flit-core
, unittestCheckHook

# for passthru.tests
, awsebcli
, black
, hatchling
, yamllint
}:

buildPythonPackage rec {
  pname = "pathspec";
  version = "0.12.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pILVFQOhqzOxxnpsOBOiaVPb3HHDHayu+ag4xOKfVxI=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  pythonImportsCheck = [
    "pathspec"
  ];

  checkInputs = [
    unittestCheckHook
  ];

  passthru.tests = {
    inherit awsebcli black hatchling yamllint;
  };

  meta = {
    description = "Utility library for gitignore-style pattern matching of file paths";
    homepage = "https://github.com/cpburnz/python-path-specification";
    changelog = "https://github.com/cpburnz/python-pathspec/blob/v${version}/CHANGES.rst";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ copumpkin ];
  };
}
