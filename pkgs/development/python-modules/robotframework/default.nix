{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  jsonschema,
  python,
}:

buildPythonPackage rec {
  pname = "robotframework";
  version = "7.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "robotframework";
    repo = "robotframework";
    tag = "v${version}";
    hash = "sha256-Kl+XjGTTiEesVi7aZJMBQQklw83ROrpaWziq+8puZKg=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ jsonschema ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} utest/run.py
    runHook postCheck
  '';

  meta = {
    changelog = "https://github.com/robotframework/robotframework/blob/master/doc/releasenotes/rf-${version}.rst";
    description = "Generic test automation framework";
    homepage = "https://robotframework.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bjornfor ];
  };
}
