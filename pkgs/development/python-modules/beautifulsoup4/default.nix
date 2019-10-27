{ stdenv, buildPythonPackage, fetchPypi, soupsieve, pytest, python }:

buildPythonPackage rec {
  pname = "beautifulsoup4";
  version = "4.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6135db2ba678168c07950f9a16c4031822c6f4aec75a65e0a97bc5ca09789931";
  };

  checkInputs = [ pytest ];
  checkPhase = ''
    py.test $out/${python.sitePackages}/bs4/tests
  '';

  propagatedBuildInputs = [ soupsieve ];

  meta = with stdenv.lib; {
    homepage = http://crummy.com/software/BeautifulSoup/bs4/;
    description = "HTML and XML parser";
    license = licenses.mit;
    maintainers = with maintainers; [ domenkozar ];
  };
}
