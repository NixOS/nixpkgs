{
  lib,
  buildPythonPackage,
  python,
  callPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  pytestCheckHook,
  configargparse,
  cryptography,
  flask,
  flask-cors,
  flask-login,
  gevent,
  geventhttpclient,
  msgpack,
  psutil,
  pyquery,
  pyzmq,
  requests,
  retry,
  tomli,
  werkzeug,
}:

buildPythonPackage rec {
  pname = "locust";
  version = "2.33.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "locustio";
    repo = "locust";
    tag = version;
    hash = "sha256-cOYdf3F1OF1P4xFEG3isuiePIl1tHnjL7UVoFIpb40A=";
  };

  postPatch = ''
    substituteInPlace locust/test/test_main.py \
      --replace-fail '"locust"' '"${placeholder "out"}/bin/locust"'

    substituteInPlace locust/test/test_log.py \
      --replace-fail '"locust"' '"${placeholder "out"}/bin/locust"'
  '';

  webui = callPackage ./webui.nix {
    inherit version;
    src = "${src}/locust/webui";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  pythonRelaxDeps = [
    # version 0.7.0.dev0 is not considered to be >= 0.6.3
    "flask-login"
  ];

  dependencies = [
    configargparse
    flask
    flask-cors
    flask-login
    gevent
    geventhttpclient
    msgpack
    psutil
    pyzmq
    requests
    tomli
    werkzeug
  ];

  pythonImportsCheck = [ "locust" ];

  nativeCheckInputs = [
    cryptography
    pyquery
    pytestCheckHook
    retry
  ];

  # locust's test suite is very flaky, due to heavy reliance on timing-based tests and access to the
  # network.
  doCheck = false;

  meta = {
    description = "Developer-friendly load testing framework";
    homepage = "https://docs.locust.io/";
    changelog = "https://github.com/locustio/locust/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jokatzke ];
  };
}
