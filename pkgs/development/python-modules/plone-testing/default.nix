{ lib
, buildPythonPackage
, fetchPypi
, six
, zope_testing
, setuptools
}:

buildPythonPackage rec {
  pname = "plone.testing";
  version = "8.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "71f22cb8cc169360786ec468a0ab5d403abe5bacc13754c251dd6b9eeedd1d83";
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
