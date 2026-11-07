{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  docutils,
  jsonschema,
  markdown,
  python,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "robotframework";
  version = "7.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "robotframework";
    repo = "robotframework";
    tag = "v${version}";
    hash = "sha256-z7qJy7sUqTIIjz6nMNiCl2cBAeqsfU/O32YceryNRpY=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    docutils
    jsonschema
    markdown
    pyyaml
  ];

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
