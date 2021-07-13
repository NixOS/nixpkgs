{ lib
, buildPythonPackage
, fetchPypi
, pyroute2-core
}:

buildPythonPackage rec {
  pname = "pyroute2-nslink";
  version = "0.6.4";

  src = fetchPypi {
    pname = "pyroute2.nslink";
    inherit version;
    sha256 = "0iz4vrv05x678ihhl2wdppxda82fxrq3d3sh7mka0pyb66a8mrik";
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
