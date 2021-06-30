{ lib
, buildPythonPackage
, fetchPypi
, capstone
, unicorn
, pefile
, python-registry
, keystone-engine
, pyelftools
, gevent
}:
buildPythonPackage rec {
  pname = "qiling";
  version = "1.2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ecaa4415eea44f6f48021c1f7794c0d9fae7d64c8e43a3ff1d5de8e99bd963aa";
  };

  propagatedBuildInputs = [
    capstone
    unicorn
    pefile
    python-registry
    keystone-engine
    pyelftools
    gevent
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
