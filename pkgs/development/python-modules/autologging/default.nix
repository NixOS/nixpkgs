{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "autologging";
  version = "1.3.2";

  src = fetchPypi {
    pname = "Autologging";
    inherit version;
    hash = "sha256-EXZZWE2Kq4z2IEb2gvjle1TZWLhXHHN/qL8Vwyk3+7Y=";
    extension = "zip";
  };

  meta = with lib; {
    homepage = "https://ninthtest.info/python-autologging/";
    description = "Easier logging and tracing for Python classes";
    license = licenses.mit;
    maintainers = with maintainers; [ twey ];
  };
}
