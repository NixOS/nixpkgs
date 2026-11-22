{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage rec {
  pname = "notify-events";
  version = "1.1.3";

  format = "setuptools";

  src = fetchPypi {
    pname = "notify_events";
    inherit version;
    hash = "sha256-5jupNcMwD/f0jLoRX3y0R0kG6Dwum2C5WgiB65SXAec=";
  };

  propagatedBuildInputs = [ requests ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "notify_events" ];

  meta = {
    description = "Python client for Notify.Events";
    homepage = "https://github.com/notify-events/python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
