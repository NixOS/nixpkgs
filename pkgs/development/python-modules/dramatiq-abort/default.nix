{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gevent,
  pytestCheckHook,
  pytest-cov-stub,
  dramatiq,
  redis,
  setuptools,
}:

buildPythonPackage rec {
  pname = "dramatiq-abort";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Flared";
    repo = "dramatiq-abort";
    tag = "v${version}";
    hash = "sha256-i5vL9yjQQambG8m6RDByr7/j8+PhDdLsai3pDrH1A4Q=";
  };

  patches = [
    # unstable now has dramatiq 2.x, so this patch is required until
    # https://github.com/Flared/dramatiq-abort/issues/37 has been resolved
    ./0001-test-add-fail_fast_default-False-for-old-behavior-in.patch
  ];
  build-system = [ setuptools ];

  dependencies = [
    dramatiq
  ];

  optional-dependencies = {
    all = lib.concatAttrValues (lib.removeAttrs optional-dependencies [ "all" ]);
    gevent = [ gevent ];
    redis = [ redis ];
  };

  nativeCheckInputs = [
    redis
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "dramatiq_abort" ];

  meta = {
    changelog = "https://github.com/Flared/dramatiq-abort/releases/tag/v${version}";
    description = "Dramatiq extension to abort message";
    homepage = "https://github.com/Flared/dramatiq-abort";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ tebriel ];
  };
}
