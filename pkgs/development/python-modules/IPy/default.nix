{ stdenv, buildPythonPackage, fetchPypi, nose }:

buildPythonPackage rec {
  pname = "IPy";
  version = "1.00";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08d6kcacj67mvh0b6y765ipccy6gi4w2ndd4v1l3im2qm1cgcarg";
  };

  checkInputs = [ nose ];

  checkPhase = ''
    nosetests -e fuzz
  '';

  meta = with stdenv.lib; {
    description = "Class and tools for handling of IPv4 and IPv6 addresses and networks";
    homepage = "https://github.com/autocracy/python-ipy";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ y0no ];
  };
}
