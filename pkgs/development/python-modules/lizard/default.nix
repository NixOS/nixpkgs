{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  mock,
  jinja2,
  pygments, # for Erlang support
  pathspec, # for .gitignore support
}:

buildPythonPackage rec {
  pname = "lizard";
  version = "1.20.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "terryyin";
    repo = "lizard";
    rev = version;
    hash = "sha256-HNpCg/ScD0aDdpVXA9Nb9QU+4ww6Kp2qIeu9Lj0O7A4=";
  };

  propagatedBuildInputs = [
    jinja2
    pygments
    pathspec
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ];

  disabledTestPaths = [
    # re.error: global flags not at the start of the expression at position 14
    "test/test_languages/testFortran.py"
  ];

  pythonImportsCheck = [ "lizard" ];

  meta = {
    changelog = "https://github.com/terryyin/lizard/blob/${version}/CHANGELOG.md";
    description = "Code analyzer without caring the C/C++ header files";
    mainProgram = "lizard";
    downloadPage = "https://github.com/terryyin/lizard";
    homepage = "http://www.lizard.ws";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jpetrucciani ];
  };
}
