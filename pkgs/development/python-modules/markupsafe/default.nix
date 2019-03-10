{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "MarkupSafe";
  version = "1.1.0";

 src = fetchPypi {
    inherit pname version;
    sha256 = "4e97332c9ce444b0c2c38dd22ddc61c743eb208d916e4265a2a3b575bdccb1d3";
  };

  meta = with stdenv.lib; {
    description = "Implements a XML/HTML/XHTML Markup safe string";
    homepage = http://dev.pocoo.org;
    license = licenses.bsd3;
    maintainers = with maintainers; [ domenkozar garbas ];
  };

}
