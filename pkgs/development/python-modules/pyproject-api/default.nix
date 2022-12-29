{ lib
, buildPythonPackage
, fetchPypi
, packaging
, toml
, tomli
, hatchling
, hatch-vcs
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyproject-api";
  version = "1.2.1";
  format = "pyproject";

  nativeBuildInputs = [
    hatchling
    hatch-vcs
    toml
  ] ++ lib.optional (pythonOlder "3.11") tomli;

  doCheck = false;
  pythonImportsCheck = [
    "pyproject_api"
  ];

  src = fetchPypi {
    pname = "pyproject_api";
    inherit version;
    hash = "sha256-CTwEfRks6tyrev1rUBJ2vyzkSt9By5wxMjRRjN3SCBg=";
  };

  meta = with lib; {
    description = "API to interact with the python pyproject.toml based projects";
    homepage = "http://pyproject_api.readthedocs.org/";
    license = licenses.mit;
  };
}
