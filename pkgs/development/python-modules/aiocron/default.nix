{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  python,
  croniter,
  tzlocal,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "aiocron";
  version = "2.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-G7ZaNq7hN+iDNZJ4OVbgx9xHi8PpJz/ChB1dDGBF5NI=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    croniter
    tzlocal
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    tzlocal
  ];

  postPatch = ''
    sed -i "/--ignore/d" setup.cfg
  '';

  postInstall = ''
    rm -rf $out/${python.sitePackages}/tests
  '';

  pythonImportsCheck = [ "aiocron" ];

  meta = with lib; {
    description = "Crontabs for asyncio";
    homepage = "https://github.com/gawel/aiocron/";
    license = licenses.mit;
    maintainers = [ maintainers.starcraft66 ];
  };
}
