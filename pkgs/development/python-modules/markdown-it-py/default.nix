{
  lib,
  attrs,
  buildPythonPackage,
  commonmark,
  fetchFromGitHub,
  flit-core,
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
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "markdown-it-py";
  version = "3.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-cmjLElJA61EysTUFMVY++Kw0pI4wOIXOyCY3To9fpQc=";
  };

  # fix downstrem usage of markdown-it-py[linkify]
  pythonRelaxDeps = [ "linkify-it-py" ];

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [ mdurl ];

  nativeCheckInputs = [
    pytest-regressions
    pytestCheckHook
  ] ++ passthru.optional-dependencies.linkify;

  # disable and remove benchmark tests
  preCheck = ''
    rm -r benchmarking
  '';
  doCheck = !stdenv.isi686;

  pythonImportsCheck = [ "markdown_it" ];

  passthru.optional-dependencies = {
    compare = [
      commonmark
      markdown
      mistletoe
      mistune
      panflute
    ];
    linkify = [ linkify-it-py ];
    plugins = [ mdit-py-plugins ];
    rtd = [
      attrs
      myst-parser
      pyyaml
      sphinx
      sphinx-copybutton
      sphinx-design
      sphinx-book-theme
    ];
  };

  meta = with lib; {
    description = "Markdown parser in Python";
    homepage = "https://markdown-it-py.readthedocs.io/";
    changelog = "https://github.com/executablebooks/markdown-it-py/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ bhipple ];
    mainProgram = "markdown-it";
  };
}
