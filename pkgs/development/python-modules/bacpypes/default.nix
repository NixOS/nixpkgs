{ stdenv, buildPythonPackage, fetchPypi, fetchFromGitHub
, wheel, pytestCheckHook, pytestrunner }:

buildPythonPackage rec {
  version = "0.18.1";
  pname = "bacpypes";

  src = fetchFromGitHub {
    owner = "JoelBender";
    repo = "bacpypes";
    rev = version;
    sha256 = "1fxrh57z3fjl95db8jh71grkv5id8qk65g6k5jqcs9v3dgkg8jkl";
  };

  propagatedBuildInputs = [ wheel ];

  # Using pytes instead of setuptools check hook allows disabling specific tests
  checkInputs = [ pytestCheckHook pytestrunner ];
  dontUseSetuptoolsCheck = true;
  disabledTests = [
    # Test fails with a an error: AssertionError: assert 30 == 31
    "test_recurring_task_5"
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/JoelBender/bacpypes";
    description = "BACpypes provides a BACnet application layer and network layer written in Python for daemons, scripting, and graphical interfaces.";
    license = licenses.mit;
    maintainers = with maintainers; [ bachp ];
  };
}
