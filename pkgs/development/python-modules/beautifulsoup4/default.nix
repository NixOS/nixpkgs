{ stdenv, buildPythonPackage, fetchPypi, soupsieve, pytest, python }:

buildPythonPackage rec {
  pname = "beautifulsoup4";
  version = "4.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "945065979fb8529dd2f37dbb58f00b661bdbcbebf954f93b32fdf5263ef35348";
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
