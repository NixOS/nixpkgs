{ lib, fetchurl, buildPythonPackage, isPy3k }:

buildPythonPackage rec {
  name = "PyWebDAV-${version}";
  version = "0.9.8";
  disabled = isPy3k;
  src = fetchurl {
    url = "mirror://pypi/p/pywebdav/${name}.tar.gz";
    sha256 = "1v10vg79h85milnq8w7yd75qq5z6297ywkn9b2kxajldzwqxn3ji";
  };
  meta = {
    homepage = http://code.google.com/p/pywebdav/;
    description = "WebDAV library including a standalone server for python";
    maintainers = with lib.maintainers; [ johbo ];
    license = lib.licenses.gpl2Plus;
  };
}
