{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "sarge";
  version = "0.1.7";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "vsajip";
    repo = pname;
    rev = version;
    sha256 = "sha256-E1alSDXj0oeyB6dN5PAtN62FPpMsCKb4R9DpfWdFtn0=";
  };

  checkInputs = [
    pytestCheckHook
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
