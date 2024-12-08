{
  lib,
  stdenv,
  buildPythonPackage,
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
  version = "0.5.0-unstable-2023-10-31";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jplana";
    repo = "python-etcd";
    rev = "5aea0fd4461bd05dd96e4ad637f6be7bceb1cee5";
    hash = "sha256-eVirStLOPTbf860jfkNMWtGf+r0VygLZRjRDjBMCVKg=";
  };

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

  meta = {
    description = "Python client for Etcd";
    homepage = "https://github.com/jplana/python-etcd";
    license = lib.licenses.mit;
  };
}
