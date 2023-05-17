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
  version = "1.4.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MEafxry/ewqlzOMu9TJMQodXLChGMYjS2jX3yv7FZJk=";
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
