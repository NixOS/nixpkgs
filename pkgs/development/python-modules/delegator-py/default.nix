{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  setuptools,
  pexpect,
}:

buildPythonPackage rec {
  version = "0.1.1";
  pname = "delegator-py";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "amitt001";
    repo = "delegator.py";
    tag = "v${version}";
    hash = "sha256-i9OZkXcDqrKnCFJBBxP8PrHxPGF7DEgZr91p+fuAyZ4=";
  };

  build-system = [ setuptools ];

  dependencies = [ pexpect ];

  pythonImportsCheck = [ "delegator" ];

  # no tests in github or pypi
  doCheck = false;

  meta = {
    description = "Subprocesses for Humans 2.0";
    homepage = "https://github.com/amitt001/delegator.py";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
