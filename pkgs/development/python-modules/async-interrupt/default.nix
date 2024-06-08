{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "async-interrupt";
  version = "1.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "async_interrupt";
    rev = "refs/tags/v${version}";
    hash = "sha256-mbvOj1ybCkDNr3je3PtFwmddkh2k/nHOerpC6hGSUYI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=async_interrupt --cov-report=term-missing:skip-covered" ""
  '';

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "async_interrupt" ];

  meta = with lib; {
    description = "Context manager to raise an exception when a future is done";
    homepage = "https://github.com/bdraco/async_interrupt";
    changelog = "https://github.com/bdraco/async_interrupt/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
