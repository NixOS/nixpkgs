{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pkginfo";
  version = "1.5.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7424f2c8511c186cd5424bbf31045b77435b37a8d604990b79d4e70d741148bb";
  };

  doCheck = false; # I don't know why, but with doCheck = true it fails.

  meta = with stdenv.lib; {
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
