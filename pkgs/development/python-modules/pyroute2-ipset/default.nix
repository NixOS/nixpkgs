{ lib
, buildPythonPackage
, fetchPypi
, pyroute2-core
}:

buildPythonPackage rec {
  pname = "pyroute2-ipset";
  version = "0.6.4";

  src = fetchPypi {
    pname = "pyroute2.ipset";
    inherit version;
    sha256 = "sha256-V6aUGYv4PGhxHoEjgNuqoRbd6ftqirO/ofNDQEACTy8=";
  };

  propagatedBuildInputs = [
    pyroute2-core
  ];

  # pyroute2 sub-modules have no tests
  doCheck = false;

  pythonImportsCheck = [
    "pr2modules.ipset"
  ];

  meta = with lib; {
    description = "Ipset module for pyroute2";
    homepage = "https://github.com/svinota/pyroute2";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    platforms = platforms.unix;
  };
}
