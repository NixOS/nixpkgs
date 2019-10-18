{ lib
, buildPythonPackage
, fetchPypi
, six
, zope_testing
, setuptools
}:

buildPythonPackage rec {
  pname = "plone.testing";
  version = "7.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2533c48b7bd54ff19da2b4f0c3ccd0a8878c46f03fadbf5f933baaf749d17690";
  };

  propagatedBuildInputs = [ six setuptools zope_testing ];

  # Huge amount of testing dependencies (including Zope2)
  doCheck = false;

  meta = {
    description = "Testing infrastructure for Zope and Plone projects";
    homepage = https://github.com/plone/plone.testing;
    license = lib.licenses.bsd3;
  };
}
