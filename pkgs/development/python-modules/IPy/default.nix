{ lib, buildPythonPackage, fetchPypi, nose }:

buildPythonPackage rec {
  pname = "IPy";
  version = "1.01";

  src = fetchPypi {
    inherit pname version;
    sha256 = "edeca741dea2d54aca568fa23740288c3fe86c0f3ea700344571e9ef14a7cc1a";
  };

  nativeCheckInputs = [ nose ];

  checkPhase = ''
    nosetests -e fuzz
  '';

  meta = with lib; {
    description = "Class and tools for handling of IPv4 and IPv6 addresses and networks";
    homepage = "https://github.com/autocracy/python-ipy";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ y0no ];
  };
}
