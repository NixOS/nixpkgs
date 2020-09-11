{ stdenv, buildPythonPackage, fetchPypi, soupsieve, pytest, python }:

buildPythonPackage rec {
  pname = "beautifulsoup4";
  version = "4.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "73cc4d115b96f79c7d77c1c7f7a0a8d4c57860d1041df407dd1aae7f07a77fd7";
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
