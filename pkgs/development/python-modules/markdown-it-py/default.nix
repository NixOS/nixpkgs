{ lib
, attrs
, buildPythonPackage
, commonmark
, fetchFromGitHub
, flit-core
, linkify-it-py
, markdown
, mdurl
, mistletoe
, mistune
, myst-parser
, panflute
, pyyaml
, sphinx
, sphinx-book-theme
, sphinx-copybutton
, sphinx-design
, pytest-regressions
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "markdown-it-py";
  version = "2.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-6UATJho3SuIbLktZtFcDrCTWIAh52E+n5adcgl49un0=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    mdurl
  ];

  nativeCheckInputs = [
    pytest-regressions
    pytestCheckHook
  ] ++ passthru.optional-dependencies.linkify;

  # disable and remove benchmark tests
  preCheck = ''
    rm -r benchmarking
  '';

  pythonImportsCheck = [
    "markdown_it"
  ];

  passthru.optional-dependencies = {
    compare = [ commonmark markdown mistletoe mistune panflute ];
    linkify = [ linkify-it-py ];
    rtd = [ attrs myst-parser pyyaml sphinx sphinx-copybutton sphinx-design sphinx-book-theme ];
  };

  meta = with lib; {
    description = "Markdown parser in Python";
    homepage = "https://markdown-it-py.readthedocs.io/";
    changelog = "https://github.com/executablebooks/markdown-it-py/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ bhipple ];
  };
}
