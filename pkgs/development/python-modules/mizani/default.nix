{ lib
, buildPythonPackage
, fetchFromGitHub
, matplotlib
, palettable
, pandas
, pytestCheckHook
, pythonOlder
, scipy
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "mizani";
<<<<<<< HEAD
  version = "0.9.2";
  format = "pyproject";

  disabled = pythonOlder "3.9";
=======
  version = "0.8.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "has2k1";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-6jdQxRqulE5hIzzmdr9kR5gsLrzt0lfJun5blJjTUY0=";
=======
    rev = "v${version}";
    hash = "sha256-VE0M5/s8/XmmAe8EE/FcHBFGc9ppVWuYOYMuajQeZww=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    matplotlib
    palettable
    pandas
    scipy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
<<<<<<< HEAD
    substituteInPlace pyproject.toml \
=======
    substituteInPlace pytest.ini \
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      --replace " --cov=mizani --cov-report=xml" ""
  '';

  pythonImportsCheck = [
    "mizani"
  ];

  meta = with lib; {
    description = "Scales for Python";
    homepage = "https://github.com/has2k1/mizani";
    changelog = "https://github.com/has2k1/mizani/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ samuela ];
  };
}
