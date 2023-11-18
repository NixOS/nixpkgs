{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, black
, codespell
, isort
, mypy
, pre-commit
, pygobject3
}:

buildPythonPackage rec {
  pname = "pygobject-stubs";
  version = "2.10.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pygobject";
    repo = "pygobject-stubs";
    rev = "refs/tags/v${version}";
    hash = "sha256-fz+qzFWl9JJu9CEVkeiV6XUIPDvwWgrfhTo/nj1EH5c=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  # This package does not include any tests.
  doCheck = false;

  meta = with lib; {
    description = "PEP 561 Typing Stubs for PyGObject";
    homepage = "https://github.com/pygobject/pygobject-stubs";
    changelog = "https://github.com/pygobject/pygobject-stubs/blob/${src.rev}/CHANGELOG.md";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ hacker1024 ];
  };
}
