{ lib
, buildPythonPackage
, fetchPypi
, pyroute2-core
}:

buildPythonPackage rec {
  pname = "pyroute2-nslink";
  version = "0.6.1";

  src = fetchPypi {
    pname = "pyroute2.nslink";
    inherit version;
    sha256 = "0hjdi863imppirjrwr87xk2mfbw2djcsh7x94cq4xwps7bxmmkwk";
  };

  propagatedBuildInputs = [
    pyroute2-core
  ];

  # pyroute2 sub-modules have no tests
  doCheck = false;

  pythonImportsCheck = [
    "pr2modules.nslink"
  ];

  meta = with lib; {
    description = "Nslink module for pyroute2";
    homepage = "https://github.com/svinota/pyroute2";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    platforms = platforms.unix;
  };
}
