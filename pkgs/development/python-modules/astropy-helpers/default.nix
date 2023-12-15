{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "astropy-helpers";
  version = "4.0.1";
  format = "setuptools";

  disabled = !isPy3k;

  doCheck = false; # tests requires sphinx-astropy

  src = fetchPypi {
    inherit pname version;
    sha256 = "f1096414d108778218d6bea06d4d9c7b2ff7c83856a451331ac194e74de9f413";
  };

  meta = with lib; {
    description = "Utilities for building and installing Astropy, Astropy affiliated packages, and their respective documentation";
    homepage = "https://github.com/astropy/astropy-helpers";
    license = licenses.bsd3;
    maintainers = [ maintainers.smaret ];
  };
}
