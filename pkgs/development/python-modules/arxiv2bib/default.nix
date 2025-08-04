{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  mock,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "arxiv2bib";
  version = "1.0.8";
  format = "setuptools";

  # Missing tests on Pypi
  src = fetchFromGitHub {
    owner = "nathangrigg";
    repo = "arxiv2bib";
    rev = version;
    sha256 = "1kp2iyx20lpc9dv4qg5fgwf83a1wx6f7hj1ldqyncg0kn9xcrhbg";
  };

  nativeCheckInputs = [
    unittestCheckHook
    mock
  ];
  unittestFlagsArray = [
    "-s"
    "tests"
  ];

  meta = {
    description = "Get a BibTeX entry from an arXiv id number, using the arxiv.org API";
    mainProgram = "arxiv2bib";
    homepage = "http://nathangrigg.github.io/arxiv2bib/";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.nico202 ];
  };
}
