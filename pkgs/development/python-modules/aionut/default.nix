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
  pname = "aionut";
  version = "4.3.2";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "aionut";
    rev = "refs/tags/v${version}";
    hash = "sha256-QehVC/6RbWp8KnOuVtLFkK8/STTgHXkXmFbSmzu9z7w=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail " --cov=aionut --cov-report=term-missing:skip-covered" ""
  '';

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aionut" ];

  meta = with lib; {
    description = "Asyncio Network UPS Tools";
    homepage = "https://github.com/bdraco/aionut";
    changelog = "https://github.com/bdraco/aionut/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
