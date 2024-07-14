{
  buildPythonPackage,
  fetchPypi,
  lib,
  six,
}:

buildPythonPackage rec {
  pname = "dictionaries";
  version = "0.0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-j6knRet8cHuFiIiIdSNPLwphtnk22N65Gyt7TDI2YRI=";
  };

  buildInputs = [ six ];

  meta = {
    description = "Dict implementations with attribute access";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.MostAwesomeDude ];
  };
}
