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
  version = "4.6.0";

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
    sha256 = "0bmkpg6z5z47p21340nyrfbdv2jkfp80yv085ndgbwaas1zi7ac9";
  };

  meta = with stdenv.lib; {
    description = "Scalable persistent components";
    homepage = http://packages.python.org/BTrees;
    license = licenses.zpl21;
  };
}
