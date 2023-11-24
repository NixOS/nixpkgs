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
  version = "0.11.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4NjQrC8S2mGVbrIwa2n5RptC9N6w88tu1HuczpmWztM=";
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
