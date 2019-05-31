{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "astropy-helpers";
  version = "3.1.1";

  disabled = !isPy3k;

  doCheck = false; # tests requires sphinx-astropy

  src = fetchPypi {
    inherit pname version;
    sha256 = "214cc37cffd7a21e573c4543e47b5289b07b2b77511627802d9778a4c96a5caf";
  };

  meta = with lib; {
    description = "Utilities for building and installing Astropy, Astropy affiliated packages, and their respective documentation";
    homepage = https://github.com/astropy/astropy-helpers;
    license = licenses.bsd3;
    maintainers = [ maintainers.smaret ];
  };
}
