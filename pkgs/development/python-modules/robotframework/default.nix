{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  jsonschema,
  python,
}:

buildPythonPackage rec {
  pname = "robotframework";
  version = "7.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "robotframework";
    repo = "robotframework";
    tag = "v${version}";
    hash = "sha256-SSjVrbe3uBqCMEUYjrk2lxHpxzdU6QK2xvEFszhT6lc=";
  };

  patches = [
    (fetchpatch {
      name = "fix-isatty-with-detached-buffers.patch";
      url = "https://github.com/robotframework/robotframework/commit/ca249542582f2b5d69a409e32bc7e11967ff7237.patch";
      hash = "sha256-/Vc5SUPhJkamrJyfgl/9SZb1OiGTsbZMQHDDpizR0L4=";
    })
  ];

  build-system = [ setuptools ];

  nativeCheckInputs = [ jsonschema ];

  checkPhase = ''
    ${python.interpreter} utest/run.py
  '';

  meta = {
    changelog = "https://github.com/robotframework/robotframework/blob/master/doc/releasenotes/rf-${version}.rst";
    description = "Generic test automation framework";
    homepage = "https://robotframework.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bjornfor ];
  };
}
