{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, ffmpeg-python
, orjson
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "reolink-aio";
  version = "0.7.6";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "starkillerOG";
    repo = "reolink_aio";
    rev = "refs/tags/${version}";
    hash = "sha256-muxM9+3D8WL2muw5yxbYKmbkVc5lTcj9XQOr67hb/pU=";
  };

  postPatch = ''
    # Packages in nixpkgs is different than the module name
    substituteInPlace setup.py \
      --replace "ffmpeg" "ffmpeg-python"
  '';

  propagatedBuildInputs = [
    aiohttp
    ffmpeg-python
    orjson
    requests
  ];

  # All tests require a network device
  doCheck = false;

  pythonImportsCheck = [
    "reolink_aio"
  ];

  meta = with lib; {
    description = "Module to interact with the Reolink IP camera API";
    homepage = "https://github.com/starkillerOG/reolink_aio";
    changelog = "https://github.com/starkillerOG/reolink_aio/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
