{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, glibcLocales
, pycodestyle
, pytestCheckHook
, pythonOlder
, tomli
}:

buildPythonPackage rec {
  pname = "autopep8";
  version = "2.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hhatto";
    repo = "autopep8";
    rev = "refs/tags/v${version}";
    hash = "sha256-YEPSsUzJG4MPiiloVAf9m/UiChkhkN0+lK6spycpSvo=";
  };

  patches = [
    # Ignore DeprecationWarnings to fix tests on Python 3.11, https://github.com/hhatto/autopep8/pull/665
    (fetchpatch {
      name = "ignore-deprecation-warnings.patch";
      url = "https://github.com/hhatto/autopep8/commit/75b444d7cf510307ef67dc2b757d384b8a241348.patch";
      hash = "sha256-5hcJ2yAuscvGyI7zyo4Cl3NEFG/fZItQ8URstxhzwzE=";
    })
  ];

  propagatedBuildInputs = [
    pycodestyle
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  nativeCheckInputs = [
    glibcLocales
    pytestCheckHook
  ];

  LC_ALL = "en_US.UTF-8";

  meta = with lib; {
    changelog = "https://github.com/hhatto/autopep8/releases/tag/v${version}";
    description = "A tool that automatically formats Python code to conform to the PEP 8 style guide";
    homepage = "https://github.com/hhatto/autopep8";
    license = licenses.mit;
    maintainers = with maintainers; [ bjornfor ];
  };
}
