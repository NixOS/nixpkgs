{ lib, buildPythonPackage, fetchPypi, pythonOlder }:

buildPythonPackage rec {
  pname = "oocsi";
  version = "0.4.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "020xfjvcgicj81zl3z9wnb2f9bha75bjw512b0cc38w66bniinjq";
  };

  # Tests are not shipped
  doCheck = false;

  pythonImportsCheck = [ "oocsi" ];

  meta = with lib; {
    description = "OOCSI library for Python";
    homepage = "https://github.com/iddi/oocsi-python";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
