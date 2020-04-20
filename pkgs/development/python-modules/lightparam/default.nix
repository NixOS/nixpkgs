{ lib, pkgs, buildPythonPackage, fetchPypi, isPy3k
, numpy
}:

buildPythonPackage rec {
  pname = "lightparam";
  version = "0.3.7";
  disabled = !isPy3k;
  format = "wheel";

  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    python = "py3";
    sha256 = "53d5d5b225bac27bc14929c9ad4e51ece4f692813dd367f317fb1586145d93f1";
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
