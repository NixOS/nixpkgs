{ lib, buildPythonPackage, fetchPypi, isPy36, immutables }:

buildPythonPackage rec {
  pname = "contextvars";
  version = "2.2";
  disabled = !isPy36;

  src = fetchPypi {
    inherit pname version;
    sha256 = "046b385nfzkjh0wqmd268p2jkgn9fg6hz40npq7j1w3c8aqzhwvx";
  };

  propagatedBuildInputs = [ immutables ];

  meta = {
    description = "A backport of the Python 3.7 contextvars module for Python 3.6";
    homepage = https://github.com/MagicStack/contextvars;
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ catern ];
  };
}
