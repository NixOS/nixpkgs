{
  lib,
  anyio,
  buildPythonPackage,
  curio,
  fetchFromGitHub,
  httpx,
  hypothesis,
  poetry-core,
  pytest-aio,
  pytest-subtests,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  trio,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "returns";
  version = "0.23.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dry-python";
    repo = "returns";
    rev = "refs/tags/${version}";
    hash = "sha256-4ZP/wvPgqQQec/BaXuL9r7BEc2G+LztMdFul0NeEJTc=";
  };

  postPatch = ''
    sed -i setup.cfg \
      -e '/--cov.*/d' \
      -e '/--mypy.*/d'
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ typing-extensions ];

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

  preCheck = ''
    rm -rf returns/contrib/mypy
  '';

  pythonImportsCheck = [ "returns" ];

  pytestFlagsArray = [ "--ignore=typesafety" ];

  meta = with lib; {
    description = "Make your functions return something meaningful, typed, and safe!";
    homepage = "https://github.com/dry-python/returns";
    changelog = "https://github.com/dry-python/returns/blob/${version}/CHANGELOG.md";
    license = licenses.bsd2;
    maintainers = with maintainers; [ jessemoore ];
  };
}
