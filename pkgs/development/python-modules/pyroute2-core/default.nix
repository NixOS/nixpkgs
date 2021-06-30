{ lib
, buildPythonPackage
, fetchPypi
, pyroute2-core
}:

buildPythonPackage rec {
  pname = "pyroute2-core";
  version = "0.6.4";

  src = fetchPypi {
    pname = "pyroute2.core";
    inherit version;
    sha256 = "1kd5wda7nqcmrwy6b42nqgz570y99yjw3m6a1kxr8ag3859fwga5";
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
