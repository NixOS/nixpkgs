{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, libmaxminddb
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "maxminddb";
  version = "2.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-geVOU0CL1QJlDllpzLoWeAr2WewdscRLLJl+QzCl7ZY=";
  };

  buildInputs = [
    libmaxminddb
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "maxminddb"
  ];

  meta = with lib; {
    description = "Reader for the MaxMind DB format";
    homepage = "https://github.com/maxmind/MaxMind-DB-Reader-python";
    changelog = "https://github.com/maxmind/MaxMind-DB-Reader-python/blob/v${version}/HISTORY.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
