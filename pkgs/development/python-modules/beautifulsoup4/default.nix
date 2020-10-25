{ stdenv, buildPythonPackage, fetchPypi, soupsieve, pytest, python }:

buildPythonPackage rec {
  pname = "beautifulsoup4";
  version = "4.9.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "84729e322ad1d5b4d25f805bfa05b902dd96450f43842c4e99067d5e1369eb25";
  };

  checkInputs = [ pytest ];
  checkPhase = ''
    py.test $out/${python.sitePackages}/bs4/tests
  '';

  propagatedBuildInputs = [ soupsieve ];

  meta = with stdenv.lib; {
    homepage = "http://crummy.com/software/BeautifulSoup/bs4/";
    description = "HTML and XML parser";
    license = licenses.mit;
    maintainers = with maintainers; [ domenkozar ];
  };
}
