{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "cachelib";
  version = "0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13dfv0a4ahgx0wmpqv8jqhshim4229p9c1c7gcsra81pkm89p24b";
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/pallets/cachelib";
    description = "Collection of cache libraries in the same API interface";
    license = licenses.bsd3;
    maintainers = with maintainers; [ gebner ];
  };
}
