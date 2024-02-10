{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, flit-core
, pythonOlder
, docutils
, jinja2
, markdown-it-py
, mdit-py-plugins
, pyyaml
, sphinx
, typing-extensions
, beautifulsoup4
, pytest-param-files
, pytest-regressions
, sphinx-pytest
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "myst-parser";
  version = "2.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-1BW7Z+0rs5Up+VZ3vDygnhLzE9Y2BqEMnTnflboweu0=";
  };

  patches = [
    (fetchpatch {
      name = "myst-parser-sphinx7.2-compat.patch";
      url = "https://github.com/executablebooks/MyST-Parser/commit/4f670fc04c438b57a9d4014be74e9a62cc0deba4.patch";
      hash = "sha256-FCvFSsD7qQwqWjSW7R4Gx+E2jaGkifSZqaRbAglt9Yw=";
    })
  ];

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    docutils
    jinja2
    mdit-py-plugins
    markdown-it-py
    pyyaml
    sphinx
    typing-extensions
  ];

  nativeCheckInputs = [
    beautifulsoup4
    pytest-param-files
    pytest-regressions
    sphinx-pytest
    pytestCheckHook
  ] ++ markdown-it-py.optional-dependencies.linkify;

  pythonImportsCheck = [
    "myst_parser"
  ];

  disabledTests = [
    # AssertionError due to different files
    "test_basic"
    "test_footnotes"
    "test_gettext_html"
    "test_fieldlist_extension"
    # docutils 0.19 expectation mismatches
    "test_docutils_roles"
    # sphinx 6.0 expectation mismatches
    "test_sphinx_directives"
    # sphinx 5.3 expectation mismatches
    "test_render"
    "test_includes"
  ];

  meta = with lib; {
    description = "Sphinx and Docutils extension to parse MyST";
    homepage = "https://myst-parser.readthedocs.io/";
    changelog = "https://raw.githubusercontent.com/executablebooks/MyST-Parser/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ loicreynier ];
  };
}
