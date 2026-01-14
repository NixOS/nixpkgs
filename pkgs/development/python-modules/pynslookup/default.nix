{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  dnspython,
}:

buildPythonPackage rec {
  pname = "pynslookup";
  version = "1.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wesinator";
    repo = "pynslookup";
    tag = "v${version}";
    hash = "sha256-cb8oyI8D8SzBP+tm1jGPPshJYhPegYOH0RwIH03/K/A=";
  };

  build-system = [ setuptools ];

  dependencies = [ dnspython ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "nslookup" ];

  meta = {
    description = "Module to do DNS lookups";
    homepage = "https://github.com/wesinator/pynslookup";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
