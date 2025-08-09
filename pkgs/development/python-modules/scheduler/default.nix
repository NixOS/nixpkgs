{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  typeguard,
}:

buildPythonPackage rec {
  pname = "scheduler";
  version = "0.8.8";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RXWhLNJp5OSJZAmDb9kRVgy2P7djQ2DuYqovpOxJX/0=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    typeguard
  ];

  pythonImportsCheck = [ "scheduler" ];

  meta = with lib; {
    description = "Simple in-process python scheduler library with asyncio, threading and timezone support";
    homepage = "https://pypi.org/project/scheduler/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ pinpox ];
  };
}
