{ stdenv, buildPythonPackage, fetchPypi, nose }:

buildPythonPackage rec {
  pname = "beautifulsoup4";
  version = "4.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "90f8e61121d6ae58362ce3bed8cd997efb00c914eae0ff3d363c32f9a9822d10";
  };

  buildInputs = [ nose ];
  checkPhase = ''
    nosetests build
  '';

  meta = with stdenv.lib; {
    homepage = http://crummy.com/software/BeautifulSoup/bs4/;
    description = "HTML and XML parser";
    license = licenses.mit;
    maintainers = with maintainers; [ domenkozar ];
  };
}
