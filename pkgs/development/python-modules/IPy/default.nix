{ stdenv, buildPythonPackage, fetchPypi, nose }:

buildPythonPackage rec {
  pname = "IPy";
  version = "0.83";

  src = fetchPypi {
    inherit pname version;
    sha256 = "61da5a532b159b387176f6eabf11946e7458b6df8fb8b91ff1d345ca7a6edab8";
  };

  checkInputs = [ nose ];

  checkPhase = ''
    nosetests -e fuzz
  '';

  meta = with stdenv.lib; {
    description = "Class and tools for handling of IPv4 and IPv6 addresses and networks";
    homepage = https://github.com/autocracy/python-ipy;
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ y0no ];
  };
}
