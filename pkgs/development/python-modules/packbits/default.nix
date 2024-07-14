{
  stdenv,
  buildPythonPackage,
  fetchPypi,
  pyparsing,
  six,
  pytest,
  pretend,
  lib,
}:

buildPythonPackage rec {
  pname = "packbits";
  version = "0.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vGs3C7NOBKyM+oNeBsBIQ4Cv/G1ZOtuACd1sD3v/8DQ=";
  };

  meta = with lib; {
    description = "PackBits encoder/decoder for Python";
    homepage = "https://github.com/psd-tools/packbits";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ grahamc ];
  };
}
