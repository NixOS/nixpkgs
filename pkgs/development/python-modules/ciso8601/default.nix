{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pytestCheckHook
, pytz
}:

buildPythonPackage rec {
  pname = "ciso8601";
  version = "2.3.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "closeio";
    repo = "ciso8601";
    rev = "refs/tags/v${version}";
    hash = "sha256-qTpt91Wf3L6Jl7FU8sn9PvGMRd/cjhQ1mQvUaQeLFQU=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytz
  ];

  pytestFlagsArray = [
    "tests/tests.py"
  ];

  pythonImportsCheck = [ "ciso8601" ];

  meta = with lib; {
    description = "Fast ISO8601 date time parser for Python written in C";
    homepage = "https://github.com/closeio/ciso8601";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
  };
}
