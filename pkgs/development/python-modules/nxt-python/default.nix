{ lib
, buildPythonPackage
<<<<<<< HEAD
, fetchFromGitHub
, pybluez
, pytestCheckHook
, pythonOlder
, pyusb
}:

buildPythonPackage rec {
  pname = "nxt-python";
  version = "3.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "schodet";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-PWeR8xteLMxlOHcJJCtTI0o8QNzwGJVkUACmvf4tXWY=";
  };

  propagatedBuildInputs = [
    pyusb
  ];

  passthru.optional-dependencies = {
    bluetooth = [
      pybluez
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "nxt"
  ];
=======
, fetchgit
, isPy3k
, pyusb
, pybluez
, pytest
, git
}:

buildPythonPackage rec {
  version = "3.0.1";
  pname = "nxt-python";
  format = "setuptools";

  src = fetchgit {
    url = "https://github.com/schodet/nxt-python.git";
    rev = version;
    sha256 = "004c0dr6767bjiddvp0pchcx05falhjzj33rkk03rrl0ha2nhxvz";
  };

  propagatedBuildInputs = [ pyusb pybluez pytest git ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Python driver/interface for Lego Mindstorms NXT robot";
    homepage = "https://github.com/schodet/nxt-python";
<<<<<<< HEAD
    changelog = "https://github.com/schodet/nxt-python/releases/tag/${version}";
    license = licenses.gpl3Only;
=======
    license = licenses.gpl3;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ ibizaman ];
  };
}
