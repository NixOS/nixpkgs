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
  version = "0.7.8";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "starkillerOG";
    repo = "reolink_aio";
    rev = "refs/tags/${version}";
    hash = "sha256-vbSt1rD25Bt3Qac0uO0Z63JhbU5HU0p2ox046W6xyJU=";
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
