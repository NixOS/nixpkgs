{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  freezegun,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "cached-property";
  version = "2.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pydanny";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-sOThFJs18DR9aBgIpqkORU4iRmhCVKehyM3DLYUt/Wc=";
  };

  checkInputs = [
    pytestCheckHook
    freezegun
  ];

  disabledTests = [
    # https://github.com/pydanny/cached-property/issues/131
    "test_threads_ttl_expiry"
  ];

  pythonImportsCheck = [ "cached_property" ];

  meta = with lib; {
    description = "Decorator for caching properties in classes";
    homepage = "https://github.com/pydanny/cached-property";
    changelog = "https://github.com/pydanny/cached-property/releases/tag/${version}";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ericsagnes ];
  };
}
