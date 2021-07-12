{ lib
, buildPythonPackage
, fetchPypi
, pyroute2-core
}:

buildPythonPackage rec {
  pname = "pyroute2-nftables";
  version = "0.6.4";

  src = fetchPypi {
    pname = "pyroute2.nftables";
    inherit version;
    sha256 = "0mj897h86ifk4ncms71nz6qrrfzfq8hd81198vf1hm41wppgyxn1";
  };

  propagatedBuildInputs = [
    pyroute2-core
  ];

  # pyroute2 sub-modules have no tests
  doCheck = false;

  pythonImportsCheck = [
    "pr2modules.nftables"
  ];

  meta = with lib; {
    description = "Nftables module for pyroute2";
    homepage = "https://github.com/svinota/pyroute2";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    platforms = platforms.unix;
  };
}
