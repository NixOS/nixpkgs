{ lib
, buildPythonPackage
, fetchPypi
, six
, zope_testing
, setuptools
}:

buildPythonPackage rec {
  pname = "plone.testing";
  version = "7.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "db71bde0d4d3c273dbba8c7a2ab259a42f038eca74184da36c5aab61e90e8dd7";
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
