{
  lib,
  buildPythonPackage,
  faker,
  fetchFromGitHub,
  mock,
  pytest-cov-stub,
  pytestCheckHook,
  python-memcached,
  pythonOlder,
  setuptools,
  zstd,
  stdenv,
}:

buildPythonPackage rec {
  pname = "pymemcache";
  version = "4.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pinterest";
    repo = "pymemcache";
    rev = "v${version}";
    hash = "sha256-WgtHhp7lE6StoOBfSy9+v3ODe/+zUC7lGrc2S4M68+M=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    faker
    mock
    pytest-cov-stub
    pytestCheckHook
    python-memcached
    zstd
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.is32bit [
    # test_compressed_complex is broken on 32-bit platforms
    # this can be removed on the next version bump
    # see also https://github.com/pinterest/pymemcache/pull/480
    "test_compressed_complex"
  ];

  pythonImportsCheck = [ "pymemcache" ];

  meta = with lib; {
    changelog = "https://github.com/pinterest/pymemcache/blob/${src.rev}/ChangeLog.rst";
    description = "Python memcached client";
    homepage = "https://pymemcache.readthedocs.io/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
