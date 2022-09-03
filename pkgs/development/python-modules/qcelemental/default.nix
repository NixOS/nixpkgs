{ stdenv
, buildPythonPackage
, lib
, fetchPypi
, networkx
, numpy
, pint
, pydantic
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "qcelemental";
  version = "0.25.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-v1yu6yBEtgVsheku/8YaIaXrsVgMzcFlWAuySPhYgyQ=";
  };

  propagatedBuildInputs = [
    networkx
    numpy
    pint
    pydantic
  ];

  checkInputs = [
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
