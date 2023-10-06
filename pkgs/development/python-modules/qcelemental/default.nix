{ stdenv
, buildPythonPackage
, lib
, fetchPypi
, networkx
, numpy
, pint
, pydantic
, poetry-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "qcelemental";
  version = "0.26.0";

  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oU6FEM2/2mRe8UYcGv0C77WZMRcz27pfg/zR1haKbd0=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    networkx
    numpy
    pint
    pydantic
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "qcelemental"
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Periodic table, physical constants and molecule parsing for quantum chemistry";
    homepage = "http://docs.qcarchive.molssi.org/projects/qcelemental/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sheepforce ];
  };
}
