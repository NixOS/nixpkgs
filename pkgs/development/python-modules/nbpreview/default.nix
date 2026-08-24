{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  pythonRelaxDepsHook,
  rich,
  typer,
  nbformat,
  pygments,
  ipython,
  lxml,
  pylatexenc,
  httpx,
  jinja2,
  html2text,
  pillow,
  picharsso,
  validators,
  yarl,
  markdown-it-py,
  mdit-py-plugins,
  click-help-colors,
  term-image,
}:
buildPythonPackage (finalAttrs: {
  pname = "nbpreview";
  version = "0.10.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-YUTywDFf/2+D57pSaUnTcggKx3hTzCTJhRSaBO9eWao=";
  };

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    rich
    typer
    nbformat
    pygments
    ipython
    lxml
    pylatexenc
    httpx
    jinja2
    html2text
    pillow
    picharsso
    validators
    yarl
    markdown-it-py
    mdit-py-plugins
    click-help-colors
    term-image
  ];

  pythonRelaxDeps = [
    "pillow"
    "markdown-it-py"
    "typer"
    "types-click"
  ];

  postPatch = ''
    sed -i '/types-click/d' pyproject.toml
  '';

  doCheck = false;

  meta = {
    description = "A terminal viewer for Jupyter notebooks";
    longDescription = ''
      nbpreview renders Jupyter notebooks in your terminal.
      It's like cat for .ipynb files — syntax-highlighted code cells,
      rendered markdown, images, LaTeX, DataFrames, and more.
    '';
    homepage = "https://github.com/paw-lu/nbpreview";
    changelog = "https://github.com/paw-lu/nbpreview/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alikaansun ];
    mainProgram = "nbpreview";
  };
})
