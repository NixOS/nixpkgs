{ lib
, buildPythonPackage
, fetchPypi
, pyroute2-core
}:

buildPythonPackage rec {
  pname = "pyroute2-nftables";
  version = "0.6.12";

  src = fetchPypi {
    pname = "pyroute2.nftables";
    inherit version;
    sha256 = "sha256-jy04M73r49LxfbHAuDgSaoFWmkc0O/jPJwdDlW8YCSc=";
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
