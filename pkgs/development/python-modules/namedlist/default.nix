{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "namedlist";
  version = "1.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "34f89fc992592c80b39a709e136edcf41ea17f24ba31eaf84a314a02c8b9bcef";
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
    homepage = "https://gitlab.com/ericvsmith/namedlist";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ivan ];
  };
}
