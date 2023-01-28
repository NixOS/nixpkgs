{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, poetry-core
, pydantic
, pythonOlder
}:

buildPythonPackage rec {
  pname = "huum";
  version = "0.7.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/NWeQfYmSRiWH/9lfpRZbpKygC5m/bTjogK/1UGdH2Y=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    pydantic
  ];

  # Tests are not shipped and source not tagged
  # https://github.com/frwickst/pyhuum/issues/2
  doCheck = false;

  pythonImportsCheck = [
    "huum"
  ];

  meta = with lib; {
    description = "Library for for Huum saunas";
    homepage = "https://github.com/frwickst/pyhuum";
    changelog = "https://github.com/frwickst/pyhuum/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
