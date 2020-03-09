{ lib
, buildPythonPackage
, fetchPypi
, six
, zope_testing
, setuptools
}:

buildPythonPackage rec {
  pname = "plone.testing";
  version = "7.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "160f130f641578fbede2e47686f1b58179efa9ff98ccdd1ad198b5d0c7e02474";
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
