{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aiohwenergy";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DCSBL";
    repo = "aiohwenergy";
    tag = version;
    hash = "sha256-WfkwIxyDzLNzhWNWST/V3iN9Bhu2oXDwGiA5UXCq5ho=";
  };

  postPatch = ''
    # Replace async_timeout with asyncio.timeout
    substituteInPlace aiohwenergy/hwenergy.py \
      --replace-fail "async_timeout" "asyncio"
  '';

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "aiohwenergy" ];

  meta = with lib; {
    description = "Python library to interact with the HomeWizard Energy devices API";
    homepage = "https://github.com/DCSBL/aiohwenergy";
    changelog = "https://github.com/DCSBL/aiohwenergy/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
