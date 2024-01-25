{ lib
, aiohttp
, buildPythonPackage
, colorlog
, fetchFromGitHub
, pint
, poetry-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiocomelit";
  version = "0.7.4";
  format = "pyproject";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "chemelli74";
    repo = "aiocomelit";
    rev = "refs/tags/v${version}";
    hash = "sha256-F/blKd+6n/mTeqgmA5rVGz8DFJA+317T6sjYfsAAf2E=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=aiocomelit --cov-report=term-missing:skip-covered" ""
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    pint
  ];

  nativeCheckInputs = [
    colorlog
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aiocomelit"
  ];

  meta = with lib; {
    description = "Library to control Comelit Simplehome";
    homepage = "https://github.com/chemelli74/aiocomelit";
    changelog = "https://github.com/chemelli74/aiocomelit/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
