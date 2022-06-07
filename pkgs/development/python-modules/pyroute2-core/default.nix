{ lib
, buildPythonPackage
, fetchPypi
, pyroute2-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyroute2-core";
  version = "0.6.10";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "pyroute2.core";
    inherit version;
    hash = "sha256-hwI7sSaR0938VeCShzZ39b2CAU5SJLqui8Ri3CGXPwk=";
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
