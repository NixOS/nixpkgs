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
, python-registry
, pyyaml
, unicorn
}:

buildPythonPackage rec {
  pname = "qiling";
  version = "1.4.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sndRKknfY3LgqUf6FOobwczIStjzZkudVgUR1EQSyeU=";
  };

  propagatedBuildInputs = [
    capstone
    gevent
    keystone-engine
    multiprocess
    pefile
    pyelftools
    python-registry
    pyyaml
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
    license = licenses.gpl2Only;
    maintainers = teams.determinatesystems.members;
  };
}
