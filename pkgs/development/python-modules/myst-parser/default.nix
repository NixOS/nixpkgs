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
  version = "0.18.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-wgRZwafAF05LtwjH6SVKzsY7bKeZ6lUlM3dB5PdOn1E=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "docutils>=0.15,<0.19" "docutils>=0.15" \
      --replace "sphinx>=4,<6" "sphinx"
  '';

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

  nativeCheckInputs = [
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
    # sphinx 6.0 expectation mismatches
    "test_sphinx_directives"
  ];

  meta = with lib; {
    description = "Sphinx and Docutils extension to parse MyST";
    homepage = "https://myst-parser.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ loicreynier ];
  };
}
