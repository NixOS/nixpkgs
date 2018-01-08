{ buildPythonPackage , fetchPypi , python , stdenv }:

buildPythonPackage rec {
  pname = "arxiv2bib";
  version = "1.0.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1a27nrlcj283spgs9y07rgpwcihgkd5rclh16na6bnm4ibnhhxhk";
  };

  meta = {
    homepage    = "http://nathangrigg.github.io/arxiv2bib";
    description = "Get arXiv.org metadata in BibTeX format";
    license     = stdenv.lib.licenses.bsd;
    maintainers = with stdenv.lib.maintainers; [ matthiasbeyer ];
  };
}

