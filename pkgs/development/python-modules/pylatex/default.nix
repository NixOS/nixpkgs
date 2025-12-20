{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  ordered-set,
  pytestCheckHook,
  matplotlib,
  quantities,
  texlive,
}:

buildPythonPackage rec {
  pname = "pylatex";
  version = "1.4.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "JelteF";
    repo = "PyLaTeX";
    rev = "v${version}";
    hash = "sha256-R6u2HDDLsli/omrtEKSRTH8Pd99gBI4iM+O0cZhoSJc=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ordered-set ];

  pythonImportsCheck = [
    "pylatex"
    "pylatex.base_classes"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    matplotlib
    quantities
    (texlive.combine { inherit (texlive) scheme-small lastpage collection-fontsrecommended; })
  ];

  meta = {
    description = "Python library for creating LaTeX files and snippets";
    homepage = "https://jeltef.github.io/PyLaTeX/current/";
    downloadPage = "https://github.com/JelteF/PyLaTeX/releases";
    changelog = "https://jeltef.github.io/PyLaTeX/current/changelog.html";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ MayNiklas ];
  };
}
