{
  lib,
  buildPythonPackage,
  commonmark,
  fetchFromGitHub,
  flit-core,
  ipykernel,
  jupyter-sphinx,
  linkify-it-py,
  markdown,
  mdit-py-plugins,
  mdurl,
  mistletoe,
  mistune,
  myst-parser,
  panflute,
  pyyaml,
  sphinx,
  sphinx-book-theme,
  sphinx-copybutton,
  sphinx-design,
  stdenv,
  pytest-regressions,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "markdown-it-py";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = "markdown-it-py";
    tag = "v${version}";
    hash = "sha256-92J9cMit2zwyjoE8G1YpwDxj+wiApQW2eUHxUOUt3as=";
  };

  # fix downstrem usage of markdown-it-py[linkify]
  pythonRelaxDeps = [ "linkify-it-py" ];

  build-system = [
    flit-core
  ];

  dependencies = [ mdurl ];

  nativeCheckInputs = [
    pytest-regressions
    pytestCheckHook
  ]
  ++ optional-dependencies.linkify;

  # disable and remove benchmark tests
  preCheck = ''
    rm -r benchmarking
  '';
  doCheck = !stdenv.hostPlatform.isi686;

  pythonImportsCheck = [ "markdown_it" ];

  optional-dependencies = {
    compare = [
      commonmark
      markdown
      mistletoe
      mistune
      panflute
      # FIXME package markdown-it-pyrs
    ];
    linkify = [ linkify-it-py ];
    plugins = [ mdit-py-plugins ];
    rtd = [
      mdit-py-plugins
      myst-parser
      pyyaml
      sphinx
      sphinx-copybutton
      sphinx-design
      sphinx-book-theme
      jupyter-sphinx
      ipykernel
    ];
  };

  meta = {
    description = "Markdown parser in Python";
    homepage = "https://markdown-it-py.readthedocs.io/";
    changelog = "https://github.com/executablebooks/markdown-it-py/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "markdown-it";
  };
}
