{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "cachelib";
  version = "0.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "47e95a67d68c729cbad63285a790a06f0e0d27d71624c6e44c1ec3456bb4476f";
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/pallets/cachelib";
    description = "Collection of cache libraries in the same API interface";
    license = licenses.bsd3;
    maintainers = with maintainers; [ gebner ];
  };
}
