{ lib, buildPythonPackage, fetchPypi, isPy36, immutables }:

buildPythonPackage rec {
  pname = "contextvars";
  version = "2.3";
  disabled = !isPy36;

  src = fetchPypi {
    inherit pname version;
    sha256 = "09fnni8cyxm070bfv9ay030qbyk0dfds5nq77s0p38h33hp08h93";
  };

  # pull request for this patch is https://github.com/MagicStack/contextvars/pull/9
  patches = [ ./immutables_version.patch ];
  propagatedBuildInputs = [ immutables ];

  meta = {
    description = "A backport of the Python 3.7 contextvars module for Python 3.6";
    homepage = https://github.com/MagicStack/contextvars;
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ catern ];
  };
}
