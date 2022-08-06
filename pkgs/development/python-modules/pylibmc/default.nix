{ buildPythonPackage, fetchPypi, lib, libmemcached, zlib, cyrus_sasl }:

buildPythonPackage rec {
  version = "1.6.2";
  pname = "pylibmc";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-QatJ05VAdnN0iRvvC+tSkcqXvrcEi3r3dSEGSVPATcA=";
  };

  buildInputs = [ libmemcached zlib cyrus_sasl ];
  setupPyBuildFlags = [ "--with-sasl2" ];

  # requires an external memcached server running
  doCheck = false;

  meta = with lib; {
    description = "Quick and small memcached client for Python";
    homepage = "http://sendapatch.se/projects/pylibmc/";
    license = licenses.bsd3;
  };
}
