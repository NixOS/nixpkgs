{ stdenv
, buildPythonPackage
, fetchPypi
, libxml2
, libxslt
}:

buildPythonPackage rec {
  pname = "lxml";
  version = "4.2.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7035d9361f3ceec9ccc1dd3482094d1174580e7e1bf6870b77ea758f7cad15d2";
  };

  nativeBuildInputs = [ libxml2.dev libxslt.dev ];
  buildInputs = [ libxml2 libxslt ];

  hardeningDisable = stdenv.lib.optional stdenv.isDarwin "format";

  meta = {
    description = "Pythonic binding for the libxml2 and libxslt libraries";
    homepage = https://lxml.de;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ sjourdois ];
  };
}
