{ lib
, callPackage
, buildPythonPackage
, fetchFromGitHub
, mkdocs
, poetry
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mkdocs-same-dir";
  version = "v0.1.2";

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "oprypin";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-U83FAjytrmc3ezIrpGQSesflP6o7/d8FZcqDlCDxmiw=";
  };

  propagatedBuildInputs = [
    mkdocs
    poetry
  ];

  # No tests for python
  doCheck = false;

  pythonImportsCheck = [
    "mkdocs"
  ];

  meta = with lib; {
    description = "Material for mkdocs-same-dir";
    homepage = "https://oprypin.github.io/mkdocs-same-dir/";
    license = licenses.mit;
    maintainers = [];
  };
}
