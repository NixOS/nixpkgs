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
  version = "0.8.11";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-siNKBpRIphervFEbnhj0jE3rPc2dzFFyHZyQ7ylDtyo=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    typeguard
  ];

  pythonImportsCheck = [ "scheduler" ];

  meta = {
    description = "Simple in-process python scheduler library with asyncio, threading and timezone support";
    homepage = "https://pypi.org/project/scheduler/";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ pinpox ];
  };
}
