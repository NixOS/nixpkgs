{ lib
, buildPythonPackage
, fetchPypi
, pyroute2-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyroute2-ipset";
  version = "0.6.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "pyroute2.ipset";
    inherit version;
    hash = "sha256-roNLNXmnW27a+TgxtMi8HO5hF4agxdjQ0DMsYW6O44c=";
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
