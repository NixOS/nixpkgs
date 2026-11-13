{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  jsonschema,
  python,
  pyyaml,
  markdown,
  docutils,
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
  dependencies = [
    pyyaml
    markdown
    docutils
  ];

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
