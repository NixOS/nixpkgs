{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  yarl,
}:

buildPythonPackage rec {
  pname = "gridnet";
  version = "5.0.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "klaasnicolaas";
    repo = "python-gridnet";
    tag = "v${version}";
    hash = "sha256-HVBUAasK7lFsj/tT0j70x/2w4RJtnHWfX/1XbfKKLf8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "0.0.0" "${version}"
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "gridnet" ];

  meta = with lib; {
    description = "Asynchronous Python client for NET2GRID devices";
    homepage = "https://github.com/klaasnicolaas/python-gridnet";
    changelog = "https://github.com/klaasnicolaas/python-gridnet/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
