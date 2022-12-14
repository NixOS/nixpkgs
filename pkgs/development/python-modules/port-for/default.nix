{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pytest-cov,
}:
buildPythonPackage rec {
  pname = "port-for";
  version = "0.6.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "kmike";
    repo = "port-for";
    rev = "v${version}";
    hash = "sha256-1+wP7KHcfQOvOYdn9WaugVNthoDcSsUKKT+84vpG+/k=";
  };

  nativeBuildInputs = [setuptools];

  checkInputs = [pytestCheckHook pytest-cov];

  pythonImportsCheck = ["port_for"];

  meta = with lib; {
    description = "Utility that helps with local TCP ports management";
    homepage = https://github.com/kmike/port-for/;
    license = licenses.mit;
    maintainers = [maintainers.apeschar];
    platforms = platforms.all;
  };
}
