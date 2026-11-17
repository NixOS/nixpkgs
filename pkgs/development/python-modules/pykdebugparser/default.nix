{
  buildPythonPackage,
  click,
  construct,
  fetchFromGitHub,
  lib,
  pygments,
  pytestCheckHook,
  setuptools,
  termcolor,
}:

buildPythonPackage rec {
  pname = "pykdebugparser";
  version = "1.2.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "matan1008";
    repo = "pykdebugparser";
    tag = "v${version}";
    hash = "sha256-V6WyFsPcjiBUJ+Amc3xk0GwdHzwakRizB/dPnSXT6vo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    construct
    pygments
    termcolor
  ];

  pythonImportsCheck = [ "pykdebugparser" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/matan1008/pykdebugparser/releases/tag/${src.tag}";
    description = "Kdebug events and ktraces parser";
    homepage = "https://github.com/matan1008/pykdebugparser";
    license = lib.licenses.mit;
    mainProgram = "pykdebugparser";
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
