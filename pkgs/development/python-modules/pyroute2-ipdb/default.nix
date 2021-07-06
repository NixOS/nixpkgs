{ lib
, buildPythonPackage
, fetchPypi
, pyroute2-core
}:

buildPythonPackage rec {
  pname = "pyroute2-ipdb";
  version = "0.6.4";

  src = fetchPypi {
    pname = "pyroute2.ipdb";
    inherit version;
    sha256 = "0r4xq7h39qac309lpl7haaa4rqf6qzsypkgnsiran3w9jgr1hg75";
  };

  propagatedBuildInputs = [
    pyroute2-core
  ];

  # pyroute2 sub-modules have no tests
  doCheck = false;

  pythonImportsCheck = [
    "pr2modules.ipdb"
  ];

  meta = with lib; {
    description = "Ipdb module for pyroute2";
    homepage = "https://github.com/svinota/pyroute2";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    platforms = platforms.unix;
  };
}
