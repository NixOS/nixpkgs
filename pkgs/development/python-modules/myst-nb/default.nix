{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, fetchpatch
, flit-core
, importlib-metadata
, ipython
, jupyter-cache
, nbclient
, myst-parser
, nbformat
, pyyaml
, sphinx
, sphinx-togglebutton
, typing-extensions
, ipykernel
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "myst-nb";
  version = "0.17.2";

  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-D2E4ZRX6sHxzZGrcqX//L2n0HpDTE6JgIXxbvkGdhYs=";
  };

  patches = [
    # Fix compatiblity with myst-parser 1.0. Remove with the next release.
    (fetchpatch {
      url = "https://github.com/executablebooks/MyST-NB/commit/48c45c6a8c4501005766c2d821b5e9ddfbedd5fa.patch";
      hash = "sha256-jGL2MjZArvPtbiaR/rRGCIi0QwYO0iTIK26GLuTrBM8=";
      excludes = [
        "myst_nb/__init__.py"
        "docs/authoring/custom-formats.Rmd"
        "docs/authoring/jupyter-notebooks.md"
        "docs/index.md"
        "pyproject.toml"
        "tests/nb_fixtures/reporter_warnings.txt"
      ];
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "myst-parser~=0.18.0" "myst-parser"
  '';

  nativeBuildInputs = [
    flit-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    importlib-metadata
    ipython
    jupyter-cache
    nbclient
    myst-parser
    nbformat
    pyyaml
    sphinx
    sphinx-togglebutton
    typing-extensions
    ipykernel
  ];

  pythonRelaxDeps = [
    "myst-parser"
  ];

  pythonImportsCheck = [
    "myst_nb"
    "myst_nb.sphinx_ext"
  ];

  meta = with lib; {
    description = "A Jupyter Notebook Sphinx reader built on top of the MyST markdown parser";
    homepage = "https://github.com/executablebooks/MyST-NB";
    changelog = "https://github.com/executablebooks/MyST-NB/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
