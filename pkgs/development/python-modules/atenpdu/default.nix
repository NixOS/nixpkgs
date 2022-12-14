{ lib
, buildPythonPackage
, fetchPypi
, async-timeout
, pysnmp
, pythonOlder
}:

buildPythonPackage rec {
  pname = "atenpdu";
  version = "0.3.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cl7PZdIdLGvoYd5x7QyjkTBc+pVB9F7En9sxcUoX34Q=";
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
