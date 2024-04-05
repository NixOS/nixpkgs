{ lib
, buildPythonPackage
, setuptools
, wheel
, fetchPypi
}:

buildPythonPackage rec {
  pname = "ping3";
  version = "4.0.5";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HwkYXokyFDZSSZayEtID08q1rSJofedGRXDxx/udwFE=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "ping3" ];

  meta = with lib; {
    description = "A pure python3 version of ICMP ping implementation using raw socket";
    mainProgram = "ping3";
    homepage = "https://pypi.org/project/ping3";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
