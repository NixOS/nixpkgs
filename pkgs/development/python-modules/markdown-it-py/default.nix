{ lib
, attrs
, buildPythonPackage
, fetchFromGitHub
, flit-core
, linkify-it-py
, mdurl
, psutil
, py
, pytest-benchmark
, pytest-regressions
, pytestCheckHook
, pythonOlder
, typing-extensions
# allow disabling tests for the nixos manual build.
# the test suite closure is just too large.
, disableTests ? false
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
    attrs
    linkify-it-py
    mdurl
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  nativeCheckInputs = [
    psutil
    py
  ] ++ lib.optionals (! disableTests) [
    pytest-benchmark
    pytest-regressions
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "--benchmark-skip"
  ];

  pythonImportsCheck = [
    "markdown_it"
  ];

  meta = with lib; {
    description = "Markdown parser in Python";
    homepage = "https://markdown-it-py.readthedocs.io/";
    changelog = "https://github.com/executablebooks/markdown-it-py/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ bhipple ];
  };
}
