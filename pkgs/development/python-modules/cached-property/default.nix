{ lib
, buildPythonPackage
, fetchPypi
, freezegun
}:

buildPythonPackage rec {
  pname = "cached-property";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a2fa0f89dd422f7e5dd992a4a3e0ce209d5d1e47a4db28fd0a7b5273ec8da3f0";
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