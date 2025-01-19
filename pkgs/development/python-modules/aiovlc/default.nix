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
  version = "0.6.5";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "MartinHjelmare";
    repo = "aiovlc";
    tag = "v${version}";
    hash = "sha256-tE+2jmIemDoWJCG4/zsoB3yXeUnFgob8LdCT/eiLZbY=";
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
