{
  lib,
  buildPythonPackage,
  pytestCheckHook,
  fetchFromGitHub,
  setuptools,
  marisa-trie,
  meta-memcache-socket,
  prometheus-client,
  pytest-mock,
  uhashring,
  zstandard,
}:
buildPythonPackage rec {
  pname = "meta-memcache";
  version = "2.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RevenueCat";
    repo = "meta-memcache-py";
    tag = "v2.0.2";
    hash = "sha256-cgtifhEHm3XJ0teEmHk26MXhttOiydRApAAu2cMxffI=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    marisa-trie
    meta-memcache-socket
    uhashring
    zstandard
  ];

  optional-dependencies = {
    metrics = [
      prometheus-client
    ];
  };

  pythonImportsCheck = [
    "meta_memcache"
  ];

  nativeCheckInputs = [
    prometheus-client
    pytestCheckHook
    pytest-mock
  ];

  meta = {
    description = "Modern, pure python, memcache client with support for new meta commands";
    homepage = "https://github.com/RevenueCat/meta-memcache-py";
    changelog = "https://github.com/RevenueCat/meta-memcache-py/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ typedrat ];
  };
}
