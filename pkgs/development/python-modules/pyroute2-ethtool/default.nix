{ lib
, buildPythonPackage
, fetchPypi
, pyroute2-core
}:

buildPythonPackage rec {
  pname = "pyroute2-ethtool";
  version = "0.6.5";

  src = fetchPypi {
    pname = "pyroute2.ethtool";
    inherit version;
    sha256 = "sha256-yvgBS2dlIRNcR2DXLPWu72q7x/onUhD36VMzBzzHcVo=";
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
