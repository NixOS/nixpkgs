{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-git,
  pytest,
}:

buildPythonPackage rec {
  pname = "pytest-fixture-config";
  version = "1.7.1-unstable-2022-10-03";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "man-group";
    repo = "pytest-plugins";
    rev = "5f9b88a65a8c1e506885352bbd9b2a47900f5014";
    hash = "sha256-huN3RzwtfVf4iMJ96VRP/ldOxTUlUMF1wJIdbcGXHn4=";
  };

  sourceRoot = "${src.name}/pytest-fixture-config";

  nativeBuildInputs = [
    setuptools
    setuptools-git
  ];

  buildInputs = [ pytest ];

  doCheck = false;

  meta = with lib; {
    description = "Simple configuration objects for Py.test fixtures. Allows you to skip tests when their required config variables aren’t set";
    homepage = "https://github.com/manahl/pytest-plugins";
    license = licenses.mit;
    maintainers = with maintainers; [ ryansydnor ];
  };
}
