{ lib
, buildPythonPackage
, capstone
, fetchFromGitHub
, fetchPypi
, gevent
, keystone-engine
, multiprocess
, pefile
, pyelftools
, pythonOlder
, python-fx
, python-registry
, pyyaml
, questionary
, termcolor
, unicorn
}:

buildPythonPackage rec {
  pname = "qiling";
<<<<<<< HEAD
  version = "1.4.6";
=======
  version = "1.4.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-l3WQBlJic4lXCe5Z1FmoxaqOblE7uAaW2gG/nTn84Kc=";
=======
    hash = "sha256-MEafxry/ewqlzOMu9TJMQodXLChGMYjS2jX3yv7FZJk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    capstone
    gevent
    keystone-engine
    multiprocess
    pefile
    pyelftools
    python-fx
    python-registry
    pyyaml
    termcolor
    questionary
    unicorn
  ];

  # Tests are broken (attempt to import a file that tells you not to import it,
  # amongst other things)
  doCheck = false;

  pythonImportsCheck = [
    "qiling"
  ];

  meta = with lib; {
    description = "Qiling Advanced Binary Emulation Framework";
    homepage = "https://qiling.io/";
    changelog = "https://github.com/qilingframework/qiling/releases/tag/${version}";
    license = licenses.gpl2Only;
    maintainers = [ ];
  };
}
