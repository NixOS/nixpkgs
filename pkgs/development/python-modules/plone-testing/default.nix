{ lib
, buildPythonPackage
, fetchPypi
, six
, zope-testing
, setuptools
}:

buildPythonPackage rec {
  pname = "plone.testing";
  version = "8.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "39bc23bbb59b765702090ad61fe579f8bd9fe1f005f4dd1c2988a5bd1a71faf0";
  };

  propagatedBuildInputs = [ six setuptools zope-testing ];

  # Huge amount of testing dependencies (including Zope2)
  doCheck = false;

  meta = {
    description = "Testing infrastructure for Zope and Plone projects";
    homepage = "https://github.com/plone/plone.testing";
    license = lib.licenses.bsd3;
  };
}
