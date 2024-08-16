{
  lib,
  aetcd,
  buildPythonPackage,
  coredis,
  deprecated,
  etcd3,
  fetchFromGitHub,
  hiro,
  importlib-resources,
  motor,
  packaging,
  pymemcache,
  pymongo,
  pytest-asyncio,
  pytest-lazy-fixture,
  pytestCheckHook,
  pythonOlder,
  redis,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "limits";
  version = "3.12.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "alisaifee";
    repo = "limits";
    rev = "refs/tags/${version}";
    # Upstream uses versioneer, which relies on git attributes substitution.
    # This leads to non-reproducible archives on github. Remove the substituted
    # file here, and recreate it later based on our version info.
    postFetch = ''
      rm "$out/limits/_version.py"
    '';
    hash = "sha256-EH2/75tcKuS11XKuo4lCQrFe4/XJZpcWhuGlSuhIk18=";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace-fail "--cov=limits" "" \
      --replace-fail "-K" ""

    substituteInPlace setup.py \
      --replace-fail "versioneer.get_version()" "'${version}'"

    # Recreate _version.py, deleted at fetch time due to non-reproducibility.
    echo 'def get_versions(): return {"version": "${version}"}' > limits/_version.py
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    deprecated
    importlib-resources
    packaging
    typing-extensions
  ];

  passthru.optional-dependencies = {
    redis = [ redis ];
    rediscluster = [ redis ];
    memcached = [ pymemcache ];
    mongodb = [ pymongo ];
    etcd = [ etcd3 ];
    async-redis = [ coredis ];
    # async-memcached = [
    #   emcache  # Missing module
    # ];
    async-mongodb = [ motor ];
    async-etcd = [ aetcd ];
  };

  doCheck = pythonOlder "3.12"; # SystemError in protobuf

  nativeCheckInputs = [
    hiro
    pytest-asyncio
    pytest-lazy-fixture
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [ "limits" ];

  pytestFlagsArray = [
    # All other tests require a running Docker instance
    "tests/test_limits.py"
    "tests/test_ratelimit_parser.py"
    "tests/test_limit_granularities.py"
  ];

  meta = with lib; {
    description = "Rate limiting using various strategies and storage backends such as redis & memcached";
    homepage = "https://github.com/alisaifee/limits";
    changelog = "https://github.com/alisaifee/limits/releases/tag/${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
