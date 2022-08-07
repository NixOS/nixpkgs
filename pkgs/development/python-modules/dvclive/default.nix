{ lib
, buildPythonPackage
, dvc-render
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, tabulate
}:

buildPythonPackage rec {
  pname = "dvclive";
  version = "0.10.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-4sixsWZNnI3UJRlFyB21eAdUCgF8iIZ56ECgIeFV/u8=";
  };

  propagatedBuildInputs = [
    dvc-render
    tabulate # will be available as dvc-render.optional-dependencies.table
  ];

  # Circular dependency with dvc
  doCheck = false;

  pythonImportsCheck = [
    "dvclive"
  ];

  meta = with lib; {
    description = "Library for logging machine learning metrics and other metadata in simple file formats";
    homepage = "https://github.com/iterative/dvclive";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
