{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-timeout,
  pytestCheckHook,
  pythonOlder,
  typer,
}:

buildPythonPackage rec {
  pname = "aiovlc";
  version = "0.6.3";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "MartinHjelmare";
    repo = "aiovlc";
    rev = "refs/tags/v${version}";
    hash = "sha256-b4QtTR/p2wmVk4LZdkWwzM1odx1cxjUF08pV/zunTx4=";
  };

  build-system = [ poetry-core ];

  optional-dependencies = {
    cli = [ typer ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytest-timeout
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "aiovlc" ];

  meta = with lib; {
    description = "Python module to control VLC";
    homepage = "https://github.com/MartinHjelmare/aiovlc";
    changelog = "https://github.com/MartinHjelmare/aiovlc/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
