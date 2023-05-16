{ lib
<<<<<<< HEAD
, argcomplete
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, backoff
, buildPythonPackage
, fetchFromGitHub
, importlib-metadata
, parameterized
, poetry-core
, pytest-mock
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, requests
, requests-mock
, responses
, rich
}:

buildPythonPackage rec {
  pname = "censys";
<<<<<<< HEAD
  version = "2.2.5";
=======
  version = "2.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "censys";
    repo = "censys-python";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-D25deUPMWc6KRlwytSfZqoPeJGmTV304slUP9gCyrUw=";
=======
    hash = "sha256-CtW6EN9oH/OIZ4XaoSuKlMYK9Mh/ewRs6y34xbfY234=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
<<<<<<< HEAD
    argcomplete
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    backoff
    requests
    rich
    importlib-metadata
  ];

  nativeCheckInputs = [
    parameterized
    pytest-mock
    pytestCheckHook
    requests-mock
    responses
  ];

  pythonRelaxDeps = [
    "backoff"
    "requests"
    "rich"
  ];

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--cov" ""
  '';

  # The tests want to write a configuration file
  preCheck = ''
    export HOME=$(mktemp -d)
    mkdir -p $HOME
  '';

  pythonImportsCheck = [
    "censys"
  ];

  meta = with lib; {
    description = "Python API wrapper for the Censys Search Engine (censys.io)";
    homepage = "https://github.com/censys/censys-python";
<<<<<<< HEAD
    changelog = "https://github.com/censys/censys-python/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
