{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, flit-core
, click
, docutils
, jinja2
, jsonschema
, linkify-it-py
, myst-nb
, pyyaml
, sphinx
, sphinx-comments
, sphinx-copybutton
, sphinx-external-toc
, sphinx-jupyterbook-latex
, sphinx-design
, sphinx-thebe
, sphinx-book-theme
, sphinx-togglebutton
, sphinxcontrib-bibtex
, sphinx-multitoc-numbering
}:

buildPythonPackage rec {
  pname = "jupyter-book";
  version = "0.13.1";

  format = "flit";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-RgpC/H4J3kbdZsKuwYu7EOKCqcgM2v4uUsm6PVFknQE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "jsonschema<4" "jsonschema" \
      --replace "sphinx-external-toc~=0.2.3" "sphinx-external-toc" \
      --replace "sphinx-jupyterbook-latex~=0.4.6" "sphinx-jupyterbook-latex" \
      --replace "sphinx-thebe~=0.1.1" "sphinx-thebe" \
      --replace "sphinx>=4,<5" "sphinx" \
      --replace "sphinx_book_theme~=0.3.2" "sphinx_book_theme" \
      --replace "myst-nb~=0.13.1" "myst-nb" \
      --replace "docutils>=0.15,<0.18" "docutils" \
      --replace "sphinx-design~=0.1.0" "sphinx-design" \
      --replace "linkify-it-py~=1.0.1" "linkify-it-py"
  '';

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    click
    docutils
    jinja2
    jsonschema
    linkify-it-py
    myst-nb
    pyyaml
    sphinx
    sphinx-comments
    sphinx-copybutton
    sphinx-external-toc
    sphinx-jupyterbook-latex
    sphinx-design
    sphinx-thebe
    sphinx-book-theme
    sphinx-togglebutton
    sphinxcontrib-bibtex
    sphinx-multitoc-numbering
  ];

  pythonImportsCheck = [ "jupyter_book" ];

  meta = with lib; {
    description = "Build a book with Jupyter Notebooks and Sphinx";
    homepage = "https://executablebooks.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ marsam ];
  };
}
