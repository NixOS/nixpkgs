{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  nose,
}:

buildPythonPackage rec {
  pname = "nose-xunitmp";
  version = "0.4.1";
  pyproject = true;

  src = fetchPypi {
    pname = "nose_xunitmp";
    inherit version;
    hash = "sha256-wt9y9HYHUdMBU9Rzgiqr8afD1GL2ZKp/f9uNxibcfEA=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [ nose ];

  pythonImportsCheck = [ "nose_xunitmp" ];

  meta = {
    description = "Xunit output when running multiprocess tests using nose";
    homepage = "https://pypi.org/project/nose_xunitmp/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
