{ lib
, fetchFromGitHub
, fetchpatch
, buildPythonPackage
, pycodestyle
, glibcLocales
, tomli
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "autopep8";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "hhatto";
    repo = "autopep8";
    rev = "v${version}";
    sha256 = "sha256-77ZVprACHUP8BmylTtvHvJMjb70E1YFKKdQDigAZG6s=";
  };

  patches = [
    (fetchpatch {
      name = "fix-pycodestyle-2.10.0.patch";
      url = "https://github.com/hhatto/autopep8/pull/659.patch";
      hash = "sha256-ulvQqJ3lUm8/9QZwH+whzrxbz8c11/ntc8zH2zfmXiE=";
    })
  ];

  propagatedBuildInputs = [ pycodestyle tomli ];

  checkInputs = [
    glibcLocales
    pytestCheckHook
  ];

  LC_ALL = "en_US.UTF-8";

  meta = with lib; {
    description = "A tool that automatically formats Python code to conform to the PEP 8 style guide";
    homepage = "https://pypi.org/project/autopep8/";
    license = licenses.mit;
    maintainers = with maintainers; [ bjornfor ];
  };
}
