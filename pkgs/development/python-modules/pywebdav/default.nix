{ stdenv, fetchPypi, buildPythonPackage, isPy3k }:

buildPythonPackage rec {
  pname = "PyWebDAV";
  version = "0.9.8";
  disabled = isPy3k;
  src = fetchPypi {
    inherit pname version;
    sha256 = "1v10vg79h85milnq8w7yd75qq5z6297ywkn9b2kxajldzwqxn3ji";
  };
  meta = with stdenv.lib; {
    homepage = http://code.google.com/p/pywebdav/;
    description = "WebDAV library including a standalone server for python";
    maintainers = with maintainers; [ johbo ];
    license = licenses.gpl2Plus;
  };
}
