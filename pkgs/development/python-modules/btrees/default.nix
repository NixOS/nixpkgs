{ stdenv
, fetchPypi
, buildPythonPackage
, persistent
, zope_interface
, transaction
, zope_testrunner
}:

buildPythonPackage rec {
  pname = "BTrees";
  version = "4.5.1";

  buildInputs = [ transaction ];
  propagatedBuildInputs = [ persistent zope_interface ];
  checkInputs = [ zope_testrunner ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "dcc096c3cf92efd6b9365951f89118fd30bc209c9af83bf050a28151a9992786";
  };

  meta = with stdenv.lib; {
    description = "Scalable persistent components";
    homepage = http://packages.python.org/BTrees;
    license = licenses.zpl21;
  };
}
