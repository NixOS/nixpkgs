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
  version = "0.13.0";

  format = "flit";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0a956677e7bbee630dd66641c09a84091277887d6dcdd381a676f00fa9de2074";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "jsonschema<4" "jsonschema" \
      --replace "sphinx-external-toc~=0.2.3" "sphinx-external-toc" \
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
