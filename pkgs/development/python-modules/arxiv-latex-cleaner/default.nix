{ lib
, buildPythonPackage
, setuptools-scm
, pythonOlder
, pythonRelaxDepsHook
, fetchFromGitHub
, pytestCheckHook
, absl-py
, pillow
, pyyaml
, regex
}:

buildPythonPackage rec {
  pname = "arxiv-latex-cleaner";
  version = "1.0.5";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "google-research";
    repo = "arxiv-latex-cleaner";
    rev = "refs/tags/v${version}";
    hash = "sha256-Yxp8XtlISVZfEjCEJ/EXsIGMCHDPOwPcjkJxECeXvYk=";
  };

  nativeBuildInputs = [
    setuptools-scm
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    absl-py
    pillow
    pyyaml
    regex
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonRelaxDeps = [ "absl_py" ];

  pythonImportsCheck = [ "arxiv_latex_cleaner" ];

  meta = {
    description = "This tool allows you to easily clean the LaTeX code of your paper to submit to arXiv.";
    homepage = "https://github.com/google-research/arxiv-latex-cleaner";
    downloadPage = "https://github.com/google-research/arxiv-latex-cleaner/releases";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ chrispattison ];
  };
}
