{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pytestCheckHook
, freezegun
, pythonOlder
}:

buildPythonPackage rec {
  pname = "cached-property";
  version = "1.5.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pydanny";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-DGI8FaEjFd2bDeBDKcA0zDCE+5I6meapVNZgycE1gzs=";
  };

  patches = [
    # Don't use asyncio.coroutine if it's not available, https://github.com/pydanny/cached-property/pull/267
    (fetchpatch {
      name = "asyncio-coroutine.patch";
      url = "https://github.com/pydanny/cached-property/commit/297031687679762849dedeaf24aa3a19116f095b.patch";
      hash = "sha256-qolrUdaX7db4hE125Lt9ICmPNYsD/uBmQrdO4q5NG3c=";
    })
  ];

  checkInputs = [
    pytestCheckHook
    freezegun
  ];

  disabledTests = [
    # https://github.com/pydanny/cached-property/issues/131
    "test_threads_ttl_expiry"
  ];

  pythonImportsCheck = [
    "cached_property"
  ];

  meta = with lib; {
    description = "A decorator for caching properties in classes";
    homepage = "https://github.com/pydanny/cached-property";
    changelog = "https://github.com/pydanny/cached-property/releases/tag/${version}";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ericsagnes ];
  };
}
