{ lib
, buildPythonPackage
, fetchPypi
, freezegun
}:

buildPythonPackage rec {
  pname = "cached-property";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6562f0be134957547421dda11640e8cadfa7c23238fc4e0821ab69efdb1095f3";
  };

  checkInputs = [ freezegun ];

  meta = {
    description = "A decorator for caching properties in classes";
    homepage = https://github.com/pydanny/cached-property;
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ericsagnes ];
  };
}