{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "sarge";
  version = "0.1.7.post1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "vsajip";
    repo = pname;
    rev = version;
    sha256 = "sha256-bT1DbcQi+SbeRBsL7ILuQbSnAj3BBB4+FNl+Zek5xU4=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Aarch64-linux times out for these tests, so they need to be disabled.
    "test_timeout"
    "test_feeder"
  ];

  pythonImportsCheck = [
    "sarge"
  ];

  meta = with lib; {
    description = "Python wrapper for subprocess which provides command pipeline functionality";
    homepage = "https://sarge.readthedocs.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ abbradar ];
  };
}
