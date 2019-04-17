{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "astropy-helpers";
  version = "3.1";

  disabled = !isPy3k;

  doCheck = false; # tests requires sphinx-astropy

  src = fetchPypi {
    inherit pname version;
    sha256 = "37caf1f21bfdf653f7bb9f5b070dc1bb59cd70c0e09f9c5742401f57400a6e52";
  };

  meta = with lib; {
    description = "Utilities for building and installing Astropy, Astropy affiliated packages, and their respective documentation";
    homepage = https://github.com/astropy/astropy-helpers;
    license = licenses.bsd3;
    maintainers = [ maintainers.smaret ];
  };
}
