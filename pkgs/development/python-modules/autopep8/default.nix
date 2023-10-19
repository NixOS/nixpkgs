{ lib
, buildPythonPackage
, fetchFromGitHub
, glibcLocales
, pycodestyle
, pytestCheckHook
, pythonOlder
, tomli
}:

buildPythonPackage rec {
  pname = "autopep8";
  version = "2.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hhatto";
    repo = "autopep8";
    rev = "refs/tags/v${version}";
    hash = "sha256-+EZgo7xtYKMgpcntU5FtPrfikDDpnvGHhorhtoqDsvE=";
  };

  propagatedBuildInputs = [
    pycodestyle
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  nativeCheckInputs = [
    glibcLocales
    pytestCheckHook
  ];

  env.LC_ALL = "en_US.UTF-8";

  meta = with lib; {
    changelog = "https://github.com/hhatto/autopep8/releases/tag/v${version}";
    description = "A tool that automatically formats Python code to conform to the PEP 8 style guide";
    homepage = "https://github.com/hhatto/autopep8";
    license = licenses.mit;
    maintainers = with maintainers; [ bjornfor ];
  };
}
