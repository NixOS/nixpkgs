{ stdenv
, buildPythonPackage
, lib
, fetchPypi
, poetry-core
, networkx
, numpy
, pint
, pydantic
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "qcelemental";
  version = "0.27.0";

  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5VLNGD4glAIGgtt+q8YvwyAQvJU9mfyTpngwVr6gOYg=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

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
