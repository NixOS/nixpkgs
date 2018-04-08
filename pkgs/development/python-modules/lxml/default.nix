{ stdenv
, buildPythonPackage
, fetchPypi
, libxml2
, libxslt
}:

buildPythonPackage rec {
  pname = "lxml";
  version = "4.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e2629cdbcad82b83922a3488937632a4983ecc0fed3e5cfbf430d069382eeb9b";
  };

  buildInputs = [ libxml2 libxslt ];

  hardeningDisable = stdenv.lib.optional stdenv.isDarwin "format";

  meta = {
    description = "Pythonic binding for the libxml2 and libxslt libraries";
    homepage = http://lxml.de;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ sjourdois ];
  };
}