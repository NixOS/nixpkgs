{ lib
, buildPythonPackage
, fetchPypi
, pyroute2-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyroute2-nslink";
  version = "0.6.9";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "pyroute2.nslink";
    inherit version;
    hash = "sha256-WZjRexKn1FWXj+5KZxqZXB0aZmnd0ECKWt3hvVDdz4w=";
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
