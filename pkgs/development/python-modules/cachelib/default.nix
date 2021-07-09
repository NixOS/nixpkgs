{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "cachelib";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-3LX6/mtrVEqqjQyssS1wu/m79ywEHxf8rRYY23vt6to=";
  };

  meta = with lib; {
    homepage = "https://github.com/pallets/cachelib";
    description = "Collection of cache libraries in the same API interface";
    license = licenses.bsd3;
    maintainers = with maintainers; [ gebner ];
  };
}
