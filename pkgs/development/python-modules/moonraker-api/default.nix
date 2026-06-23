{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-aiohttp,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "moonraker-api";
  version = "4.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "cmroche";
    repo = "moonraker-api";
    tag = "v${version}";
    hash = "sha256-I+/c3dVVuNGKWztVsEKi2AErACbhQoU8ZE3ye9B2HxM=";
  };

  postPatch = ''
    # see comment on https://github.com/cmroche/moonraker-api/commit/e5ca8ab60d2839e150a81182fbe65255d84b4e4e
    substituteInPlace setup.py \
      --replace 'name="moonraker-api",' 'name="moonraker-api",version="${version}",'
  '';

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [ "moonraker_api" ];

  meta = {
    description = "Python API for the Moonraker API";
    homepage = "https://github.com/cmroche/moonraker-api";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
