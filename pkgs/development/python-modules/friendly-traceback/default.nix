{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
, pytestCheckHook
, asttokens
, executing
, pure-eval
, six
, stack-data
}:

buildPythonPackage rec {
  pname = "friendly-traceback";
  version = "unstable-2022-11-28";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "friendly-traceback";
    repo = "friendly-traceback";
    rev = "ac62c2e661310342e25f7c78d12749df483d2dbf";
    hash = "sha256-X4Z1mOQWjliW9SsyFcmLicoGEey6lQ/CwHnoxrZrj9Y=";
  };

  build-system = [
    setuptools
    wheel
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  dependencies = [
    asttokens
    executing
    pure-eval
    six
    stack-data
  ];

  pythonImportsCheck = [ "friendly_traceback" ];

  meta = {
    description = "Friendlier Python tracebacks";
    homepage = "https://github.com/friendly-traceback/friendly-traceback/tree/main";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soyouzpanda ];
    mainProgram = "friendly-traceback";
  };
}
