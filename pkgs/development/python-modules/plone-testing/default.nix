{ lib
, buildPythonPackage
, fetchPypi
, zope_testing
, setuptools
}:

buildPythonPackage rec {
  pname = "plone.testing";
  version = "5.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2ca558a910b93355b760535b233518be3a06c58e46160487bf802b6f7cb1e511";
  };

  propagatedBuildInputs = [ setuptools zope_testing ];

  # Huge amount of testing dependencies (including Zope2)
  doCheck = false;

  meta = {
    description = "Testing infrastructure for Zope and Plone projects";
    homepage = https://github.com/plone/plone.testing;
    license = lib.licenses.bsd3;
  };
}