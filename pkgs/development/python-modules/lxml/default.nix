{ stdenv
, buildPythonPackage
, fetchPypi
, libxml2
, libxslt
}:

buildPythonPackage rec {
  pname = "lxml";
  version = "4.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "da5e7e941d6e71c9c9a717c93725cda0708c2474f532e3680ac5e39ec57d224d";
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
