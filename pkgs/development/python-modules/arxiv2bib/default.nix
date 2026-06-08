{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  mock,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "arxiv2bib";
  version = "1.0.8";
  pyproject = true;

  __structuredAttrs = true;

  # Missing tests on Pypi
  src = fetchFromGitHub {
    owner = "nathangrigg";
    repo = "arxiv2bib";
    tag = finalAttrs.version;
    hash = "sha256-b8HMerITPGY9bjRIeJzpPKiBHH+uPEx2S+xSILqP4s4=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    unittestCheckHook
    mock
  ];
  unittestFlagsArray = [
    "-s"
    "tests"
  ];

  pythonImportsCheck = [ "arxiv2bib" ];

  meta = {
    description = "Get a BibTeX entry from an arXiv id number, using the arxiv.org API";
    mainProgram = "arxiv2bib";
    homepage = "http://nathangrigg.github.io/arxiv2bib/";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.nico202 ];
  };
})
