{ lib, buildPythonPackage, fetchPypi, isPy36, immutables }:

buildPythonPackage rec {
  pname = "contextvars";
  version = "2.4";
  disabled = !isPy36;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f38c908aaa59c14335eeea12abea5f443646216c4e29380d7bf34d2018e2c39e";
  };

  propagatedBuildInputs = [ immutables ];

  meta = {
    description = "A backport of the Python 3.7 contextvars module for Python 3.6";
    homepage = "https://github.com/MagicStack/contextvars";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ catern ];
  };
}
