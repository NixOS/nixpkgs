{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatchling,

  # propagated modules
  requests,
  python-dateutil,
  pycognito,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "pyemvue";
  version = "0.18.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FQ34pKRK1HDLoupMDfVaNxAhn1HbZHYi6se4ewlUWGA=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [
    requests
    python-dateutil
    pycognito
    typing-extensions
  ];

  pythonImportsCheck = [ "pyemvue" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/magico13/PyEmVue/releases/tag/v${version}";
    description = "Python library for reading data from the Emporia Vue energy monitoring system";
    homepage = "https://github.com/magico13/PyEmVue";
    license = licenses.mit;
    maintainers = with maintainers; [ presto8 ];
  };
}
