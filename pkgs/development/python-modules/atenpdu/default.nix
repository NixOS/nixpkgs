{ lib
, buildPythonPackage
, fetchPypi
, async-timeout
, pysnmp
, pythonOlder
}:

buildPythonPackage rec {
  pname = "atenpdu";
  version = "0.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mn44nChWy6z/B+gLc3MDndkRb2+geoojT/4AqwKpLXM=";
  };

  propagatedBuildInputs = [
    async-timeout
    pysnmp
  ];

  # Project has no test
  doCheck = false;

  pythonImportsCheck = [
    "atenpdu"
  ];

  meta = with lib; {
    description = "Python interface to control ATEN PE PDUs";
    homepage = "https://github.com/mtdcr/pductl";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
