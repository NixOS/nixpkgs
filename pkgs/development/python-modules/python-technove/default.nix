{
  lib,
  aiohttp,
  aresponses,
  awesomeversion,
  backoff,
  buildPythonPackage,
  cachetools,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  yarl,
}:

buildPythonPackage rec {
  pname = "python-technove";
  version = "1.2.2";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "Moustachauve";
    repo = "pytechnove";
    rev = "refs/tags/v${version}";
    hash = "sha256-kc5jR0IM2OagvmtqhicnBbrwrdk3E/iJhRIgUtKoirI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--cov" ""
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    awesomeversion
    backoff
    cachetools
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "technove" ];

  meta = with lib; {
    description = "Python library to interact with TechnoVE local device API";
    homepage = "https://github.com/Moustachauve/pytechnove";
    changelog = "https://github.com/Moustachauve/pytechnove/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
