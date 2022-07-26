{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "rzpipe";
  version = "0.4.0";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-RSgBwmtpI58caRWov+cDWLKhti+7r70VxJbCxJveEiM=";
  };

  # No native rz_core library
  doCheck = false;

  pythonImportsCheck = [
    "rzpipe"
  ];

  meta = with lib; {
    description = "Python interface for rizin";
    homepage = "https://rizin.re";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
