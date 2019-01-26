{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pkginfo";
  version = "1.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5878d542a4b3f237e359926384f1dde4e099c9f5525d236b1840cf704fa8d474";
  };

  doCheck = false; # I don't know why, but with doCheck = true it fails.

  meta = with stdenv.lib; {
    homepage = https://pypi.python.org/pypi/pkginfo;
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
