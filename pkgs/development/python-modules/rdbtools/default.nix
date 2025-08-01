{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  distutils,
  redis,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "rdbtools";
  version = "0.1.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sripathikrishnan";
    repo = "redis-rdb-tools";
    tag = "rdbtools-${version}";
    hash = "sha256-6Ht8NuyvzbS7+MeJoVC/AtlXgKwtWwUQ+n5v+mtv/2g=";
  };

  patches = [
    # https://github.com/sripathikrishnan/redis-rdb-tools/pull/205
    ./0001-parser_tests-replace-self.assert_-with-specific-asse.patch
    ./0002-tests-self.assertEquals-self.assertEqual.patch

    # These seem to be broken
    ./0001-callback_tests-skip-test_all_dumps.patch
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    distutils
    redis
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  pythonImportsCheck = [ "rdbtools" ];

  meta = {
    description = "Parse Redis dump.rdb files, Analyze Memory, and Export Data to JSON";
    homepage = "https://github.com/sripathikrishnan/redis-rdb-tools";
    changelog = "https://github.com/sripathikrishnan/redis-rdb-tools/blob/rdbtools-${version}/CHANGES";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ offline ];
  };
}
