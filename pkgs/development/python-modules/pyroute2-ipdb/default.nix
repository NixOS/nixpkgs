{ lib
, buildPythonPackage
, fetchPypi
, pyroute2-core
}:

buildPythonPackage rec {
  pname = "pyroute2-ipdb";
  version = "0.6.5";

  src = fetchPypi {
    pname = "pyroute2.ipdb";
    inherit version;
    sha256 = "sha256-8gKP0QE9iviIFQ0DPuz3U3ZXpL434MzOqYAICZYetXc=";
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
