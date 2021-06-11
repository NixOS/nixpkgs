{ lib
, buildPythonPackage
, fetchPypi
, pyroute2-core
}:

buildPythonPackage rec {
  pname = "pyroute2-core";
  version = "0.6.1";

  src = fetchPypi {
    pname = "pyroute2.core";
    inherit version;
    sha256 = "04v10rzz844w2wfpy4pkh8fxn6dminjmfm1q7ngg5wvpk5r691rj";
  };

  # pyroute2 sub-modules have no tests
  doCheck = false;

  pythonImportsCheck = [
    "pr2modules.common"
    "pr2modules.config"
    "pr2modules.proxy"
  ];

  meta = with lib; {
    description = "Core module for pyroute2";
    homepage = "https://github.com/svinota/pyroute2";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    platforms = platforms.unix;
  };
}
