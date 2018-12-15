{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "MarkupSafe";
  version = "1.0";

 src = fetchPypi {
    inherit pname version;
    sha256 = "0rdn1s8x9ni7ss8rfiacj7x1085lx8mh2zdwqslnw8xc3l4nkgm6";
  };

  meta = with stdenv.lib; {
    description = "Implements a XML/HTML/XHTML Markup safe string";
    homepage = http://dev.pocoo.org;
    license = licenses.bsd3;
    maintainers = with maintainers; [ domenkozar garbas ];
  };

}
