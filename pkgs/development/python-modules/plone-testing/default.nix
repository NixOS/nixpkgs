{ lib
, buildPythonPackage
, fetchPypi
, six
, zope_testing
, setuptools
}:

buildPythonPackage rec {
  pname = "plone.testing";
  version = "7.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "98a6e9ce8df1fdd33876e2d8c3ca3d8291612c20bd7e0811dac83b6ce10e984b";
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
