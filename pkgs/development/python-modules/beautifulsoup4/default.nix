{ stdenv, buildPythonPackage, fetchPypi, soupsieve, pytest, python }:

buildPythonPackage rec {
  pname = "beautifulsoup4";
  version = "4.8.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05fd825eb01c290877657a56df4c6e4c311b3965bda790c613a3d6fb01a5462a";
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
