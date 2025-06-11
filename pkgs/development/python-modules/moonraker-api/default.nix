{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-aiohttp,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "moonraker-api";
  version = "2.0.6";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "cmroche";
    repo = "moonraker-api";
    tag = "v${version}";
    hash = "sha256-AwSHF9BbxKBXIQdG4OX1vYYP/ST4jSz3uMMDUx0MSEg=";
  };

  postPatch = ''
    # see comment on https://github.com/cmroche/moonraker-api/commit/e5ca8ab60d2839e150a81182fbe65255d84b4e4e
    substituteInPlace setup.py \
      --replace 'name="moonraker-api",' 'name="moonraker-api",version="${version}",'
  '';

  propagatedBuildInputs = [ aiohttp ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [ "moonraker_api" ];

  meta = with lib; {
    description = "Python API for the Moonraker API";
    homepage = "https://github.com/cmroche/moonraker-api";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
