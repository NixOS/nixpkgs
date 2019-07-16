{ stdenv
, buildPythonPackage
, fetchPypi
, libxml2
, libxslt
}:

buildPythonPackage rec {
  pname = "lxml";
  version = "4.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4a03dd682f8e35a10234904e0b9508d705ff98cf962c5851ed052e9340df3d90";
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
