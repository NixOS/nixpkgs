{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "astropy-helpers";
  version = "3.2.1";

  disabled = !isPy3k;

  doCheck = false; # tests requires sphinx-astropy

  src = fetchPypi {
    inherit pname version;
    sha256 = "1klxyfvl9hbhy37n1z3mb0vm5pmd7hbsnzhjkvigz3647hmfzva6";
  };

  meta = with lib; {
    description = "Utilities for building and installing Astropy, Astropy affiliated packages, and their respective documentation";
    homepage = https://github.com/astropy/astropy-helpers;
    license = licenses.bsd3;
    maintainers = [ maintainers.smaret ];
  };
}
