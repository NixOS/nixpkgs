{ lib
, buildPythonPackage
, setuptools
, wheel
, fetchPypi
}:

buildPythonPackage rec {
  pname = "ping3";
  version = "4.0.4";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HqEqz2dS1GZmFjQf18Y5PGZM/8UQxpPvBvc2+yZ6E7o=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "ping3" ];

  meta = with lib; {
    description = "A pure python3 version of ICMP ping implementation using raw socket";
    homepage = "https://pypi.org/project/ping3";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
