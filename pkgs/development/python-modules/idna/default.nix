{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "idna";
  version = "3.6";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ns270IOwZ5iuHoaty/6KsUec+GTk7jD+TkagA9Ekkco=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    homepage = "https://github.com/kjd/idna/";
    description = "Internationalized Domain Names in Applications (IDNA)";
    license = lib.licenses.bsd3;
  };
}
