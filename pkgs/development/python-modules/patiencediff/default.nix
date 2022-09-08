{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "patiencediff";
  version = "0.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ATyTGFDomGUY8e53krBJzVgab7ked73fbIIwp63+tzI=";
  };

  meta = with lib; {
    description = "C implementation of patiencediff algorithm for Python";
    homepage = "https://github.com/breezy-team/patiencediff";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.wildsebastian ];
  };
}
