{ lib
, buildPythonPackage
, fetchFromGitHub
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
  version = "0.18.0";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-GEtrC7o5YnkuvBfQQfhG5P74QMiHz63Fdh1cC/r5CF0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "docutils>=0.15,<0.19" "docutils>=0.15"
  '';

  format = "flit";

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

  pythonImportsCheck = [ "myst_parser" ];

  checkInputs = [
    beautifulsoup4
    pytest-param-files
    pytest-regressions
    sphinx-pytest
    pytestCheckHook
  ];

  disabledTests = [
    # AssertionError due to different files
    "test_basic"
    "test_footnotes"
    "test_gettext_html"
    "test_fieldlist_extension"
    # docutils 0.19 expectation mismatches
    "test_docutils_roles"
  ];

  meta = with lib; {
    description = "Sphinx and Docutils extension to parse MyST";
    homepage = "https://myst-parser.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ loicreynier ];
  };
}
