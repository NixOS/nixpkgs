{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, fetchpatch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, mako
, parse
, parse-type
, poetry-core
, pytest
, pytestCheckHook
, pythonOlder
<<<<<<< HEAD
=======
, setuptools
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, typing-extensions
}:

buildPythonPackage rec {
  pname = "pytest-bdd";
  version = "6.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-+76jIgfDQPdIoesTr1+QUu8wmOnrdf4KT+TJr9F2Hqk=";
  };

<<<<<<< HEAD
  patches = [
    (fetchpatch {
      name = "remove-setuptools.patch";
      url = "https://github.com/pytest-dev/pytest-bdd/commit/5d8eda3a30b47d3bd27849884a851adafca765cb.patch";
      hash = "sha256-G2WHaRKlQ9HINufh8wl7+ly7HfDGobMLzzlbwDwd+o8=";
    })
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [
    poetry-core
  ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    mako
    parse
    parse-type
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
<<<<<<< HEAD
=======
    setuptools
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  preCheck = ''
    export PATH=$PATH:$out/bin
  '';

  pythonImportsCheck = [
    "pytest_bdd"
  ];

  meta = with lib; {
    description = "BDD library for the pytest";
    homepage = "https://github.com/pytest-dev/pytest-bdd";
    license = licenses.mit;
    maintainers = with maintainers; [ jm2dev ];
  };
}
