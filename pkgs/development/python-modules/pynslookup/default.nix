{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  dnspython,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pynslookup";
  version = "1.8.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "wesinator";
    repo = "pynslookup";
    rev = "refs/tags/v${version}";
    hash = "sha256-cb8oyI8D8SzBP+tm1jGPPshJYhPegYOH0RwIH03/K/A=";
  };

  build-system = [ setuptools ];

  dependencies = [ dnspython ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "nslookup" ];

  meta = with lib; {
    description = "Module to do DNS lookups";
    homepage = "https://github.com/wesinator/pynslookup";
    license = licenses.mpl20;
    maintainers = with maintainers; [ fab ];
  };
}
