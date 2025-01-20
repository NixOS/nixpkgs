{
  lib,
  buildPythonPackage,
  python,
  callPackage,
  fetchFromGitHub,
  poetry-core,
  poetry-dynamic-versioning,
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
  version = "2.32.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "locustio";
    repo = "locust";
    tag = version;
    hash = "sha256-KWPIZLdOx09iMlnczjmlzPmy32ozw0xEBZI9li+fJ24=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'script = "pre_build.py"' ""

    substituteInPlace locust/test/test_main.py \
      --replace-fail '"locust"' '"${placeholder "out"}/bin/locust"'

    substituteInPlace locust/test/test_log.py \
      --replace-fail '"locust"' '"${placeholder "out"}/bin/locust"'
  '';

  webui = callPackage ./webui.nix {
    inherit version;
    src = "${src}/locust/webui";
  };

  preBuild = ''
    mkdir -p $out/${python.sitePackages}/${pname}
    ln -sf ${webui} $out/${python.sitePackages}/${pname}/webui
  '';

  build-system = [
    poetry-core
    poetry-dynamic-versioning
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
