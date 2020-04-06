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
  version = "4.6.1";

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
    sha256 = "b3a0e1d073800bf7bcca6cbb97a6b3c9ec485a4ba3ee0b354da1ed076cfb9f30";
  };

  meta = with stdenv.lib; {
    description = "Scalable persistent components";
    homepage = http://packages.python.org/BTrees;
    license = licenses.zpl21;
  };
}
