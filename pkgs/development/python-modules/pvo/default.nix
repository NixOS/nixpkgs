{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  mashumaro,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  syrupy,
  yarl,
}:

buildPythonPackage rec {
  pname = "pvo";
  version = "2.2.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-pvoutput";
    tag = "v${version}";
    hash = "sha256-UdMcY7Va8LAW3x4CR6hIrIdwrXiHh1Hs3tK+SWBrJFE=";
  };

  postPatch = ''
    # Upstream doesn't set a version for the pyproject.toml
    substituteInPlace pyproject.toml \
      --replace "0.0.0" "${version}"
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    mashumaro
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "pvo" ];

  meta = with lib; {
    description = "Python module to interact with the PVOutput API";
    homepage = "https://github.com/frenck/python-pvoutput";
    changelog = "https://github.com/frenck/python-pvoutput/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
