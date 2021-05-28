{ lib
, buildPythonPackage
, fetchPypi
, six
, zope_testing
, setuptools
}:

buildPythonPackage rec {
  pname = "plone.testing";
  version = "8.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e079c87f821cf2e411826940e65577a88e08827cf9a2b771070f2917a439b642";
  };

  propagatedBuildInputs = [ six setuptools zope_testing ];

  # Huge amount of testing dependencies (including Zope2)
  doCheck = false;

  meta = {
    description = "Testing infrastructure for Zope and Plone projects";
    homepage = "https://github.com/plone/plone.testing";
    license = lib.licenses.bsd3;
  };
}
