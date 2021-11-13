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
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "084ad706f6803d7de2391eab928ecf4cb3e8d892fd2988666d4791a422d6ab9a";
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
