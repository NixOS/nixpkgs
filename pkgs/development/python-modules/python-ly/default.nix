{
  buildPythonPackage,
  fetchPypi,
  lib,
}:

buildPythonPackage rec {
  pname = "python-ly";
  version = "0.9.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1NK2jrDvgHMgAVQkfMm9ke1/smcayWbvPShTKBwV16g=";
  };

  # tests not shipped on `pypi` and
  # seem to be broken ATM: https://github.com/wbsoft/python-ly/issues/70
  doCheck = false;

  meta = with lib; {
    description = "Tool and library for manipulating LilyPond files";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ];
  };
}
