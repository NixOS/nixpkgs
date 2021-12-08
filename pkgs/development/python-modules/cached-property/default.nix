{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, freezegun
}:

buildPythonPackage rec {
  pname = "cached-property";
  version = "1.5.2";

  src = fetchFromGitHub {
     owner = "pydanny";
     repo = "cached-property";
     rev = "1.5.2";
     sha256 = "0fw36p0wjq6najlyd69sjbxq8c6c6k02jhz01ndxs593l4akqqhc";
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
