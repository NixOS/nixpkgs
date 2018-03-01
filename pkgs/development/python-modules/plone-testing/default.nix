{ lib
, buildPythonPackage
, fetchPypi
, zope_testing
, setuptools
}:

buildPythonPackage rec {
  pname = "plone.testing";
  version = "6.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8aa7c45237b883ea1d1c28fb465322f69310b084b9f9b6a79af64401b649dc4c";
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