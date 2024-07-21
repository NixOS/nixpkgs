{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "nanotime";
  version = "0.5.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-x8wjH8X220AbRI16tRyW0KRzP0tp+r5Wmldvif/flms=";
  };

  build-system = [ setuptools ];

  # Tests currently failing
  # https://github.com/jbenet/nanotime/issues/2
  doCheck = false;

  pythonImportsCheck = [ "nanotime" ];

  meta = with lib; {
    description = "Provides a time object that keeps time as the number of nanoseconds since the UNIX epoch";
    homepage = "https://github.com/jbenet/nanotime/tree/master/python";
    license = licenses.mit;
    maintainers = with maintainers; [ cmcdragonkai ];
  };
}
