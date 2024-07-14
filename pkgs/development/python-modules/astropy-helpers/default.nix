{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "astropy-helpers";
  version = "4.0.1";
  format = "setuptools";

  # ModuleNotFoundError: No module named 'imp'
  disabled = !isPy3k || pythonAtLeast "3.12";

  doCheck = false; # tests requires sphinx-astropy

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8QlkFNEId4IY1r6gbU2cey/3yDhWpFEzGsGU503p9BM=";
  };

  meta = with lib; {
    description = "Utilities for building and installing Astropy, Astropy affiliated packages, and their respective documentation";
    homepage = "https://github.com/astropy/astropy-helpers";
    license = licenses.bsd3;
    maintainers = [ maintainers.smaret ];
  };
}
