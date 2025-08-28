{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonAtLeast,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "lmtpd";
  version = "6.2.0";
  pyproject = true;

  # smtpd will be removed in version 3.12
  disabled = pythonOlder "3.7" || pythonAtLeast "3.12";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LGgl0v+h3gmUQEEadC9Y4bPo3uszRa3P1MLDjUuvYrM=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "lmtpd" ];

  meta = with lib; {
    description = "LMTP counterpart to smtpd in the Python standard library";
    homepage = "https://github.com/moggers87/lmtpd";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
