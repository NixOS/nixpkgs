{ lib
, anyio
, curio
, buildPythonPackage
, fetchFromGitHub
, httpx
, hypothesis
, poetry-core
, pytestCheckHook
, pytest-aio
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

  postPatch = ''
    sed -i setup.cfg \
      -e '/--cov.*/d' \
      -e '/--mypy.*/d'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    typing-extensions
  ];

  preCheck = ''
    rm -rf returns/contrib/mypy
  '';

  nativeCheckInputs = [
    anyio
    curio
    httpx
    hypothesis
    pytestCheckHook
    pytest-aio
    pytest-subtests
    setuptools
    trio
  ];

  pytestFlagsArray = [ "--ignore=typesafety" ];

  meta = with lib; {
    description = "Make your functions return something meaningful, typed, and safe!";
    homepage = "https://github.com/dry-python/returns";
    license = licenses.bsd2;
    maintainers = [ maintainers.jessemoore ];
  };
}
