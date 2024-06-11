{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  yarl,
}:

buildPythonPackage rec {
  pname = "adguardhome";
  version = "0.6.3";
  format = "pyproject";

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-${pname}";
    rev = "refs/tags/v${version}";
    hash = "sha256-V8SsWsGYmUhR9/yV6BZBK1UjYGHlDrXrF8nt0eZbTnI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--cov" "" \
      --replace '"0.0.0"' '"${version}"'

    substituteInPlace tests/test_adguardhome.py \
      --replace 0.0.0 ${version}
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    yarl
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "adguardhome" ];

  meta = with lib; {
    description = "Python client for the AdGuard Home API";
    homepage = "https://github.com/frenck/python-adguardhome";
    changelog = "https://github.com/frenck/python-adguardhome/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
