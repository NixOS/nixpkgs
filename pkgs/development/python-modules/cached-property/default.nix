{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, freezegun
}:

buildPythonPackage rec {
  pname = "cached-property";
  version = "1.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9fa5755838eecbb2d234c3aa390bd80fbd3ac6b6869109bfc1b499f7bd89a130";
  };

  checkInputs = [ pytestCheckHook freezegun ];

  disabledTests = [
    # https://github.com/pydanny/cached-property/issues/131
    "test_threads_ttl_expiry"
  ];

  meta = {
    description = "A decorator for caching properties in classes";
    homepage = "https://github.com/pydanny/cached-property";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ericsagnes ];
  };
}
