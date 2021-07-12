{ lib
, fetchPypi
, buildPythonPackage
, persistent
, zope_interface
, transaction
, zope_testrunner
}:

buildPythonPackage rec {
  pname = "BTrees";
  version = "4.9.2";

  buildInputs = [ transaction ];
  propagatedBuildInputs = [ persistent zope_interface ];
  checkInputs = [ zope_testrunner ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "d33323655924192c4ac998d9ee3002e787915d19c1e17a6baf47c9a63d9556e3";
  };

  meta = with lib; {
    description = "Scalable persistent components";
    homepage = "http://packages.python.org/BTrees";
    license = licenses.zpl21;
  };
}
