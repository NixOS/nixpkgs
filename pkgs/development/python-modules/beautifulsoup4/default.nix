{ stdenv, buildPythonPackage, fetchPypi, nose }:

buildPythonPackage rec {
  pname = "beautifulsoup4";
  version = "4.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12cf0ygpz9srpfh9gx2f9ba0swa1rzypv3sm4r0hmjyw6b4nm2w0";
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
