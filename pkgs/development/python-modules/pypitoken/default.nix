{ lib
, buildPythonPackage
, fetchFromGitHub
, jsonschema
, poetry-core
, pymacaroons
, pytest-mock
, pytestCheckHook
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "pypitoken";
<<<<<<< HEAD
  version = "7.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";
=======
  version = "6.0.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ewjoachim";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-CjSENkk1VlzrCngwFoJuq31Iai60qTJXBGMoV5QkSsE=";
=======
    hash = "sha256-1kPIVcxpFjqlAnPh71iS07n9M0qcFrwMRV8k38YxHBc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    sed -i "/--cov/d" setup.cfg
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pymacaroons
    jsonschema
    typing-extensions
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pypitoken"
  ];

  meta = with lib; {
    description = "Library for generating and manipulating PyPI tokens";
    homepage = "https://pypitoken.readthedocs.io/";
    changelog = "https://github.com/ewjoachim/pypitoken/releases/tag/6.0.3${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
