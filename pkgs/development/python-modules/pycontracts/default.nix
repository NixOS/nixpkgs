{
  lib,
  buildPythonPackage,
  fetchPypi,
  nose,
  pyparsing,
  decorator,
  six,
  future,
}:

buildPythonPackage rec {
  pname = "pycontracts";
  version = "1.8.14";

  src = fetchPypi {
    pname = "PyContracts";
    inherit version;
    hash = "sha256-icD15bnBNGj7tzK2/bMnNC2jWM731FNgYllqX1KpBQ8=";
  };

  buildInputs = [ nose ];
  propagatedBuildInputs = [
    pyparsing
    decorator
    six
    future
  ];

  meta = with lib; {
    description = "Allows to declare constraints on function parameters and return values";
    homepage = "https://pypi.python.org/pypi/PyContracts";
    license = licenses.lgpl2;
  };
}
