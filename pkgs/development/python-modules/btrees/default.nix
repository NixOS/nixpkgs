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
  version = "4.7.2";

  buildInputs = [ transaction ];
  propagatedBuildInputs = [ persistent zope_interface ];
  checkInputs = [ zope_testrunner ];

  # disable a failing test that looks broken
  postPatch = ''
    substituteInPlace BTrees/tests/common.py \
      --replace "testShortRepr" "no_testShortRepr"
  '';

  src = fetchPypi {
    inherit pname version;
    sha256 = "7ce4a5eb5c135bcb5c06b5bd1ca6fd7fd39d8631306182307ed8bc30d3033846";
  };

  meta = with stdenv.lib; {
    description = "Scalable persistent components";
    homepage = "http://packages.python.org/BTrees";
    license = licenses.zpl21;
  };
}
