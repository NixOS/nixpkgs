{ lib
, buildPythonPackage
, fetchFromGitHub
, nose
, coverage
, isPy27
, wrapt
}:

buildPythonPackage rec {
  pname = "aiounittest";
  version = "1.4.2";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "kwarunek";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-7lDOI1SHPpRZLTHRTmfbKlZH18T73poJdFyVmb+HKms=";
  };

  propagatedBuildInputs = [
    wrapt
  ];

  nativeCheckInputs = [
    nose
    coverage
  ];

  checkPhase = ''
    nosetests
  '';

  pythonImportsCheck = [ "aiounittest" ];

  meta = with lib; {
    description = "Test asyncio code more easily";
    homepage = "https://github.com/kwarunek/aiounittest";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = [ ];
=======
    maintainers = [ maintainers.costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
