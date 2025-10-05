{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  mock,
  jinja2,
  pygments, # for Erlang support
  pathspec, # for .gitignore support
}:

buildPythonPackage rec {
  pname = "lizard";
  version = "1.17.31";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "terryyin";
    repo = "lizard";
    rev = version;
    hash = "sha256-8lu4EknyAI+gn7GOSo13RRHNogpZdgxJ9fTvy7NyIsM=";
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

  meta = with lib; {
    changelog = "https://github.com/terryyin/lizard/blob/${version}/CHANGELOG.md";
    description = "Code analyzer without caring the C/C++ header files";
    mainProgram = "lizard";
    downloadPage = "https://github.com/terryyin/lizard";
    homepage = "http://www.lizard.ws";
    license = licenses.mit;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
