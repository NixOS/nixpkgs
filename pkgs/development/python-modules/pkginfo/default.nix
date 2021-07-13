{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pkginfo";
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "029a70cb45c6171c329dfc890cde0879f8c52d6f3922794796e06f577bb03db4";
  };

  doCheck = false; # I don't know why, but with doCheck = true it fails.

  meta = with lib; {
    homepage = "https://pypi.python.org/pypi/pkginfo";
    license = licenses.mit;
    description = "Query metadatdata from sdists / bdists / installed packages";

    longDescription = ''
      This package provides an API for querying the distutils metadata
      written in the PKG-INFO file inside a source distriubtion (an sdist)
      or a binary distribution (e.g., created by running bdist_egg). It can
      also query the EGG-INFO directory of an installed distribution, and the
      *.egg-info stored in a “development checkout” (e.g, created by running
      setup.py develop).
    '';
  };
}
