{ stdenv
, buildPythonPackage
, fetchPypi
, libxml2
, libxslt
}:

buildPythonPackage rec {
  pname = "lxml";
  version = "4.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "940caef1ec7c78e0c34b0f6b94fe42d0f2022915ffc78643d28538a5cfd0f40e";
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