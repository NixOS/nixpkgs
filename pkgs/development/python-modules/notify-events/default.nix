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
    sha256 = "e63ba935c3300ff7f48cba115f7cb4474906e83c2e9b60b95a0881eb949701e7";
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
