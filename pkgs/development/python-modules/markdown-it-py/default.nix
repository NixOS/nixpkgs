{ lib, buildPythonPackage, fetchFromGitHub, pytestCheckHook, pythonOlder
, attrs
, coverage
, psutil
, pytest-benchmark
}:

buildPythonPackage rec {
  pname = "markdown-it-py";
  version = "0.5.6";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = "markdown-it-py";
    rev = "v${version}";
    sha256 = "1m9g8xvd7jiz80x9hl8bw9x0ppndqq5nlcn5y8bjxnfj5s31vpbi";
  };

  propagatedBuildInputs = [ attrs ];

  checkInputs = [
    coverage
    pytest-benchmark
    psutil
    pytestCheckHook
  ];

  disabledTests = [
    # Requires the unpackaged pytest-regressions fixture plugin
    "test_amsmath"
    "test_container"
    "test_deflist"
    "test_dollarmath"
    "test_spec"
    "test_texmath"
  ];

  meta = with lib; {
    description = "Markdown parser done right";
    homepage = "https://markdown-it-py.readthedocs.io/en/latest";
    changelog = "https://github.com/executablebooks/markdown-it-py/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ bhipple ];
  };
}
