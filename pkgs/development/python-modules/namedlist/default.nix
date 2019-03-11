{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "namedlist";
  version = "1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "11n9c4a5ak9971awkf1g92m6mcmiprhrw98ik2cmjsqxmz73j2qr";
  };

  # Test file has a `unittest.main()` at the bottom that fails the tests;
  # py.test can run the tests without it.
  postPatch = ''
    substituteInPlace test/test_namedlist.py --replace "unittest.main()" ""
  '';

  checkInputs = [ pytest ];
  checkPhase = ''
    py.test
  '';

  meta = {
    description = "Similar to namedtuple, but instances are mutable";
    homepage = https://bitbucket.org/ericvsmith/namedlist;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ivan ];
  };
}
