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
  version = "0.8.2";
  format = "pyproject";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "chemelli74";
    repo = "aiocomelit";
    rev = "refs/tags/v${version}";
    hash = "sha256-SjyC/KiszQVVmctyqCn3i0DureuCtDlUhJTHC6+PQ2c=";
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
