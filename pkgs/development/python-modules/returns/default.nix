{ lib
, anyio
, curio
, buildPythonPackage
, fetchFromGitHub
, httpx
, hypothesis
, mypy
, poetry-core
, pytestCheckHook
, pytest-aio
, pytest-cov
, pytest-mypy
, pytest-mypy-plugins
, pytest-subtests
, setuptools
, trio
, typing-extensions
}:

buildPythonPackage rec {
  pname = "returns";
  version = "0.20.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "dry-python";
    repo = "returns";
    rev = "refs/tags/${version}";
    hash = "sha256-28WYjrjmu3hQ8+Snuvl3ykTd86eWYI97AE60p6SVwDQ=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    typing-extensions
  ];

  nativeCheckInputs = [
    anyio
    curio
    httpx
    hypothesis
    mypy
    pytestCheckHook
    pytest-aio
    pytest-cov
    pytest-mypy
    pytest-mypy-plugins
    pytest-subtests
    setuptools
    trio
  ];

  pytestFlagsArray = [ "--ignore=typesafety" ];

  meta = with lib; {
    description = "Make your functions return something meaningful, typed, and safe!";
    homepage = "returns.rtfd.io";
    license = licenses.bsd2;
    maintainers = [ maintainers.jessemoore ];
  };
}
