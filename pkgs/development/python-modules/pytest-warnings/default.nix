{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
}:

buildPythonPackage rec {
  pname = "pytest-warnings";
  version = "0.3.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WTn3b+BK0YKX5Trwyfs4rKHsdNuAe9QK1yczYDrbvH0=";
  };

  buildInputs = [ pytest ];

  meta = {
    description = "Plugin to list Python warnings in pytest report";
    homepage = "https://github.com/fschulze/pytest-warnings";
    license = lib.licenses.mit;
  };
}
