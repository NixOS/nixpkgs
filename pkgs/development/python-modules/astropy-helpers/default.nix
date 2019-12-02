{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "astropy-helpers";
  version = "3.2.2";

  disabled = !isPy3k;

  doCheck = false; # tests requires sphinx-astropy

  src = fetchPypi {
    inherit pname version;
    sha256 = "cf32cb008b19597a1fe1a4d97f59734f30cd513aa3369a321e7b5b86cdb623fb";
  };

  meta = with lib; {
    description = "Utilities for building and installing Astropy, Astropy affiliated packages, and their respective documentation";
    homepage = https://github.com/astropy/astropy-helpers;
    license = licenses.bsd3;
    maintainers = [ maintainers.smaret ];
  };
}
