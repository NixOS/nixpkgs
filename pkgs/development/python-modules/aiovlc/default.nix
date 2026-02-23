{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-timeout,
  pytestCheckHook,
  typer,
}:

buildPythonPackage rec {
  pname = "aiovlc";
  version = "0.6.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MartinHjelmare";
    repo = "aiovlc";
    tag = "v${version}";
    hash = "sha256-HnMzr6yKEtPFJlaKbvKYTXXjlz1wDLdOw65IPZJkWB0=";
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
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "aiovlc" ];

  meta = {
    description = "Python module to control VLC";
    homepage = "https://github.com/MartinHjelmare/aiovlc";
    changelog = "https://github.com/MartinHjelmare/aiovlc/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
