{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyyaml,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "irctokens";
  version = "2.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jesopo";
    repo = "irctokens";
    rev = "v${version}";
    hash = "sha256-Y9NBqxGUkt48hnXxsmfydHkJmWWb+sRrElV8C7l9bpw=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pyyaml
    unittestCheckHook
  ];

  pythonImportsCheck = [ "irctokens" ];

  meta = {
    description = "RFC1459 and IRCv3 protocol tokeniser library for python3";
    license = lib.licenses.mit;
    homepage = "https://github.com/jesopo/irctokens";
    maintainers = with lib.maintainers; [ hexa ];
  };
}
