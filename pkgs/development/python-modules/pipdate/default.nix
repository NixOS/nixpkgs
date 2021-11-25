{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, appdirs
, importlib-metadata
, requests
, rich
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "pipdate";
  version = "0.5.5";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03hr9i691cpg9q2xc1xr4lpd90xs8rba0xjh6qmc1vg7lgcdgbaa";
  };

  nativeBuildInputs = [ wheel ];

  propagatedBuildInputs = [
    appdirs
    requests
    rich
    setuptools
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  # Tests require network access and pythonImportsCheck requires configuration file
  doCheck = false;

  meta = with lib; {
    description = "pip update helpers";
    homepage = "https://github.com/nschloe/pipdate";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ costrouc ];
  };
}
