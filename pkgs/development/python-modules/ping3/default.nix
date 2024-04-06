{ lib
, buildPythonPackage
, setuptools
, wheel
, fetchPypi
}:

buildPythonPackage rec {
  pname = "ping3";
  version = "4.0.7";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uO2ObCZvizdGSrobagC6GDh116z5q5yIH9P8PcvpCi8=";
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
