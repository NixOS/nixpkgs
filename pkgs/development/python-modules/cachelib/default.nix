{
  lib,
  boto3,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pylibmc,
  pymongo,
  pytest-xprocess,
  pytestCheckHook,
  redis,
  uwsgi,
  valkey,
}:

buildPythonPackage (finalAttrs: {
  pname = "cachelib";
  version = "0.17.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pallets";
    repo = "cachelib";
    tag = finalAttrs.version;
    hash = "sha256-egAg0X4xpbvtiAXU6Cu/IIs8/GJAy5i73gLIkdnvOmc=";
  };

  build-system = [ flit-core ];

  optional-dependencies = {
    dynamodb = [ boto3 ];
    memcached = [ pylibmc ];
    mongodb = [ pymongo ];
    redis = [ redis ];
    uwsgi = [ uwsgi ];
    valkey = [ valkey ];
  };

  nativeCheckInputs = [
    pytest-xprocess
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  disabledTestPaths = [
    # Tests require to set up local server
    "tests/test_dynamodb_cache.py"
    "tests/test_interface_uniformity.py"
    "tests/test_memcached_cache.py"
    "tests/test_mongodb_cache.py"
    "tests/test_redis_cache.py"
    "tests/test_valkey_cache.py"
  ];

  pythonImportsCheck = [ "cachelib" ];

  meta = {
    description = "Collection of cache libraries in the same API interface";
    homepage = "https://github.com/pallets/cachelib";
    changelog = "https://github.com/pallets-eco/cachelib/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
