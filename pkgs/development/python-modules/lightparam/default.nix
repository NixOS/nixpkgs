{ lib, pkgs, buildPythonPackage, fetchPypi, isPy3k
, numpy
}:

buildPythonPackage rec {
  pname = "lightparam";
  version = "0.4.6";
  disabled = !isPy3k;
  format = "wheel";

  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    python = "py3";
    sha256 = "eca63016524208afb6a06db19baf659e698cce3ae2e57be15b37bc988549c631";
  };

  propagatedBuildInputs = [
    numpy
  ];

  meta = {
    homepage = "https://github.com/portugueslab/lightparam";
    description = "Another attempt at parameters in Python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tbenst ];
  };
}
