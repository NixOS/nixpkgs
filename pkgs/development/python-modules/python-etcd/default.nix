{
  lib,
  stdenv,
  buildPythonPackage,
  nix-update-script,
  fetchFromGitHub,
  setuptools,
  urllib3,
  dnspython,
  pytestCheckHook,
  etcd_3_4,
  mock,
  pyopenssl,
}:

buildPythonPackage {
  pname = "python-etcd";
  version = "0.4.5-unstable-2024-08-09";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jplana";
    repo = "python-etcd";
    rev = "d2889f7b23feee8797657b19c404f0d4034dd03c";
    hash = "sha256-osiSeBdZBT3w9pJUBxD7cI9/2T7eiyj6M6+87T8bTj0=";
  };

  patches = [ ./remove-getheader-usage.patch ];

  build-system = [ setuptools ];

  dependencies = [
    urllib3
    dnspython
  ];

  nativeCheckInputs = [
    pytestCheckHook
    etcd_3_4
    mock
    pyopenssl
  ];

  # arm64 is an unsupported platform on etcd 3.4. should be able to be removed on >= etcd 3.5
  doCheck = !stdenv.hostPlatform.isAarch64;

  preCheck = ''
    for file in "test_auth" "integration/test_simple"; do
      substituteInPlace src/etcd/tests/$file.py \
        --replace-fail "assertEquals" "assertEqual"
    done
  '';

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # Seems to be failing because of network restrictions
    # AttributeError: Can't get local object 'TestWatch.test_watch_indexed_generator.<locals>.watch_value'
    "test_watch"
    "test_watch_generator"
    "test_watch_indexed"
    "test_watch_indexed_generator"
  ];

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Python client for Etcd";
    homepage = "https://github.com/jplana/python-etcd";
    license = lib.licenses.mit;
  };
}
