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
, python-registry
, unicorn
}:

buildPythonPackage rec {
  pname = "qiling";
  version = "1.4.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e72dc5856cbda975f962ddf063063a32bd6c3b825f75e0795e94ba6840a7d45f";
  };

  propagatedBuildInputs = [
    capstone
    gevent
    keystone-engine
    multiprocess
    pefile
    pyelftools
    python-registry
    unicorn
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pefile==2021.5.24" "pefile>=2021.5.24"
  '';

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
