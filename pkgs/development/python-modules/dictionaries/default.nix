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
    sha256 = "8fa92745eb7c707b8588888875234f2f0a61b67936d8deb91b2b7b4c32366112";
  };

  buildInputs = [ six ];

  meta = {
    description = "Dict implementations with attribute access";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.MostAwesomeDude ];
  };
}
