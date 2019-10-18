{ stdenv
, buildPythonPackage
, fetchPypi
, libxml2
, libxslt
}:

buildPythonPackage rec {
  pname = "lxml";
  version = "4.3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "738862e9724d201f1aa8394cb666d8136d666198e97d6e1e5c9876ad884a86b3";
  };

  nativeBuildInputs = [ libxml2.dev libxslt.dev ];
  propagatedBuildInputs = [ libxml2 libxslt ];

  hardeningDisable = stdenv.lib.optional stdenv.isDarwin "format";

  meta = {
    description = "Pythonic binding for the libxml2 and libxslt libraries";
    homepage = https://lxml.de;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ sjourdois ];
  };
}
