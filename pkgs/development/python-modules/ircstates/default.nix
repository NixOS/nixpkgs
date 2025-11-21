{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  irctokens,
  pendulum,
  freezegun,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "ircstates";
  version = "0.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jesopo";
    repo = "ircstates";
    rev = "v${version}";
    hash = "sha256-Mq9aOj6PXzPjaz3ofoPcAbur59oUWffmEg8aHt0v+0Q=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "pendulum" ];

  dependencies = [
    irctokens
    pendulum
  ];

  nativeCheckInputs = [
    freezegun
    unittestCheckHook
  ];

  pythonImportsCheck = [ "ircstates" ];

  meta = {
    description = "sans-I/O IRC session state parsing library";
    license = lib.licenses.mit;
    homepage = "https://github.com/jesopo/ircstates";
    maintainers = with lib.maintainers; [ hexa ];
  };
}
