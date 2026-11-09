{
  lib,
  buildPythonPackage,
  python,
  callPackage,
  fetchFromGitHub,
  fetchpatch2,
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
  locust-cloud,
  psutil,
  pyquery,
  pytest,
  pyzmq,
  requests,
  retry,
  tomli,
  werkzeug,
}:

buildPythonPackage rec {
  pname = "locust";
  version = "2.43.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "locustio";
    repo = "locust";
    tag = version;
    hash = "sha256-+0B4S524UjvaYl7VTZ1IY7UuBuDjUBqOvjHu0UVOi6A=";
  };

  patches =
    let
      # Patch to fix CVE-2026-111883.
      url = "https://github.com/locustio/locust/commit/3a1d0caa5bde59494ede55f513fcb4becbf406a0.patch?full_index=1";
    in
    [
      # Remove when version >= 2.47.0.
      (fetchpatch2 {
        inherit url;
        hash = "sha256-qd0nwy59DlfIMwxQga0EZ+msNJW4BQxV1N0xcrYCDxY=";
        excludes = [ "locust/test/test_web.py" ];
      })
      # Remove when version >= 2.47.0.
      (fetchpatch2 {
        inherit url;
        hash = "sha256-kZWC2Hk6mIrBS9wV43Iy6OeI3Ge6cvTjTe4nzcusXww=";
        includes = [ "locust/test/test_web.py" ];
        # There are 17 hunks in total, hunks 15-17 are not present
        # in version 2.43.1, with the functions having been introduced as part
        # of release 2.47.0.
        # The functions are:
        # def test_swarm_replaces_run_time_timer(self)
        # def test_swarm_run_time_expires_and_stops_test(self):
        hunks = [ "1-14" ];
      })
    ];

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

  preBuild = ''
    mkdir -p $out/${python.sitePackages}/locust/webui/dist
    ln -sf ${webui}/dist/* $out/${python.sitePackages}/locust/webui/dist
  '';

  build-system = [
    hatchling
    hatch-vcs
  ];

  pythonRelaxDeps = [
    # version 0.7.0.dev0 is not considered to be >= 0.6.3
    "flask-login"
    # version 6.0.1 is listed as 0.0.1 in the dependency check and 0.0.1 is not >= 3.0.10
    "flask-cors"
    "requests"
  ];

  dependencies = [
    configargparse
    flask
    flask-cors
    flask-login
    gevent
    geventhttpclient
    msgpack
    locust-cloud
    psutil
    pyzmq
    requests
    tomli
    werkzeug
    pytest
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
