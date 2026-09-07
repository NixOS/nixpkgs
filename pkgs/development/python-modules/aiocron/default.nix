{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  python,
  cronsim,
  python-dateutil,
  tzlocal,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-xdist,
}:

buildPythonPackage rec {
  pname = "aiocron";
  version = "2.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-G7ZaNq7hN+iDNZJ4OVbgx9xHi8PpJz/ChB1dDGBF5NI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cronsim
    python-dateutil
    tzlocal
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pytest-xdist
    tzlocal
  ];

  postInstall = ''
    rm -rf $out/${python.sitePackages}/tests
  '';

  pythonImportsCheck = [ "aiocron" ];

  meta = {
    description = "Crontabs for asyncio";
    homepage = "https://github.com/gawel/aiocron/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.starcraft66 ];
  };
}
