{ lib
, buildPythonPackage
, fetchPypi
, pyroute2-core
}:

buildPythonPackage rec {
  pname = "pyroute2-ethtool";
  version = "0.6.1";

  src = fetchPypi {
    pname = "pyroute2.ethtool";
    inherit version;
    sha256 = "1gd2vvdkjf6ppiql3znrlzc9xg8c4gsyg2jfm76c2xf329hi66n7";
  };

  propagatedBuildInputs = [
    pyroute2-core
  ];

  # pyroute2 sub-modules have no tests
  doCheck = false;

  pythonImportsCheck = [
    "pr2modules.ethtool"
  ];

  meta = with lib; {
    description = "Ethtool module for pyroute2";
    homepage = "https://github.com/svinota/pyroute2";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    platforms = platforms.unix;
  };
}
