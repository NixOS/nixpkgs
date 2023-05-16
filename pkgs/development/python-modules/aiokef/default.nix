{ lib
, async-timeout
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, pytestCheckHook
=======
, pytest-cov
, pytestCheckHook
, pytest-mypy
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pythonOlder
, tenacity
}:

buildPythonPackage rec {
  pname = "aiokef";
  version = "0.2.17";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "basnijholt";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ms0dwrpj80w55svcppbnp7vyl5ipnjfp1c436k5c7pph4q5pxk9";
  };

<<<<<<< HEAD
  postPatch = ''
    substituteInPlace tox.ini \
      --replace "--cov --cov-append --cov-fail-under=30 --cov-report=" "" \
      --replace "--mypy" ""
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    async-timeout
    tenacity
  ];

  nativeCheckInputs = [
<<<<<<< HEAD
=======
    pytest-cov
    pytest-mypy
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pytestCheckHook
  ];

  pytestFlagsArray = [ "tests" ];
  pythonImportsCheck = [ "aiokef" ];

  meta = with lib; {
    description = "Python API for KEF speakers";
    homepage = "https://github.com/basnijholt/aiokef";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
