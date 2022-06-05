{ lib
, attrs
, buildPythonPackage
, fetchFromGitHub
, linkify-it-py
, mdurl
, psutil
, pytest-benchmark
, pytest-regressions
, pytestCheckHook
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "markdown-it-py";
  version = "2.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = pname;
    rev = "v${version}";
    sha256 = "0qrsl4ajhi2263i5q1kivp2s3n7naq3byfbsv11rni18skw3i2a6";
  };

  propagatedBuildInputs = [
    attrs
    linkify-it-py
    mdurl
  ] ++ lib.optional (pythonOlder "3.8") [
    typing-extensions
  ];

  checkInputs = [
    psutil
    pytest-benchmark
    pytest-regressions
    pytestCheckHook
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
