{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "grapheme";
  version = "0.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RMK58hu+d8+wWDX+wjC9Q1lUJ1Jn/qGFgBOxAvhgPMo=";
  };

  # Tests are no available on PyPI
  # https://github.com/alvinlindstam/grapheme/issues/18
  doCheck = false;

  pythonImportsCheck = [ "grapheme" ];

  meta = with lib; {
    description = "Python package for grapheme aware string handling";
    homepage = "https://github.com/alvinlindstam/grapheme";
    license = licenses.mit;
    maintainers = with maintainers; [ creator54 ];
  };
}
