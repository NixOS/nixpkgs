{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pylru";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "492f934bb98dc6c8b2370c02c95c65516ddc08c8f64d27f70087eb038621d297";
  };

  meta = with lib; {
    homepage = "https://github.com/jlhutch/pylru";
    description = "A least recently used (LRU) cache implementation";
    license = licenses.gpl2;
    maintainers = with maintainers; [ abbradar ];
  };
}
