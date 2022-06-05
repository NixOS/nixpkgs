{ lib
, buildPythonPackage
, fetchPypi
, pyroute2-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyroute2-ipdb";
  version = "0.6.9";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "pyroute2.ipdb";
    inherit version;
    hash = "sha256-sJ9Zzlrh9FWVWL7StyHpPPuXo6TtNLz2/lQBCl53Wrk=";
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
