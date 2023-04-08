{ buildPythonPackage
, lib
, fetchFromGitHub
, mock
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "arxiv2bib";
  version = "1.0.8";

  # Missing tests on Pypi
  src = fetchFromGitHub {
    owner = "nathangrigg";
    repo = "arxiv2bib";
    rev = version;
    sha256 = "1kp2iyx20lpc9dv4qg5fgwf83a1wx6f7hj1ldqyncg0kn9xcrhbg";
  };

  nativeCheckInputs = [ unittestCheckHook mock ];
  unittestFlagsArray = [ "-s" "tests" ];

  meta = with lib; {
    description = "Get a BibTeX entry from an arXiv id number, using the arxiv.org API";
    homepage = "http://nathangrigg.github.io/arxiv2bib/";
    license = licenses.bsd3;
    maintainers = [ maintainers.nico202 ];
  };
}
