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
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Mq9aOj6PXzPjaz3ofoPcAbur59oUWffmEg8aHt0v+0Q=";
  };

  build-system = [ setuptools ];

  dependencies = [
    irctokens
    pendulum
  ];

  nativeCheckInputs = [
    freezegun
    unittestCheckHook
  ];

  pythonImportsCheck = [ "ircstates" ];

  meta = with lib; {
    description = "sans-I/O IRC session state parsing library";
    license = licenses.mit;
    homepage = "https://github.com/jesopo/ircstates";
    maintainers = with maintainers; [ hexa ];
  };
}
