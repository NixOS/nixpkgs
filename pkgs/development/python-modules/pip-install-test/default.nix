{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage (finalAttrs: {
  pname = "pip-install-test";
  version = "0.5";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-wzxGztmGW1mWPoblSQGUdSC9tzv5GEnN27AAdCWYu2c=";
  };

  pythonImportsCheck = [ "pip_install_test" ];

  meta = {
    description = "Minimal stub package to test success of pip install";
    homepage = "https://pypi.org/project/pip-install-test";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
