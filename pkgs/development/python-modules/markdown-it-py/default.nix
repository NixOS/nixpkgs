{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, attrs
, linkify-it-py
, psutil
, pytest-benchmark
, pytest-regressions
, typing-extensions
}:

buildPythonPackage rec {
  pname = "markdown-it-py";
  version = "1.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = pname;
    rev = "v${version}";
    sha256 = "0h7rn3rcqfwmnqs97qczwkw9w5g4df8bgn6sw7k149svfqgrkf56";
  };

  propagatedBuildInputs = [ attrs linkify-it-py ]
    ++ lib.optional (pythonOlder "3.8") typing-extensions;

  checkInputs = [
    psutil
    pytest-benchmark
    pytest-regressions
    pytestCheckHook
  ];
  pythonImportsCheck = [ "markdown_it" ];

  meta = with lib; {
    description = "Markdown parser done right";
    homepage = "https://markdown-it-py.readthedocs.io/en/latest";
    changelog = "https://github.com/executablebooks/markdown-it-py/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ bhipple ];
  };
}
