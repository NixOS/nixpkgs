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
  version = "1.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e3ed09f9e080559e73e2a9199649b934b3594f653079d1e7da4992340c19eb64";
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
