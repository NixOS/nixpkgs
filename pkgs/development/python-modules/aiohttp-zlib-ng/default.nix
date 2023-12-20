{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, aiohttp
, zlib-ng
}:

buildPythonPackage rec {
  pname = "aiohttp-zlib-ng";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "aiohttp-zlib-ng";
    rev = "v${version}";
    hash = "sha256-dTNwt4eX6ZQ8ySK2/9ziVbc3KFg2aL/EsiBWaJRC4x8=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    zlib-ng
  ];

  pythonImportsCheck = [ "aiohttp_zlib_ng" ];

  meta = with lib; {
    description = "Enable zlib_ng on aiohttp";
    homepage = "https://github.com/bdraco/aiohttp-zlib-ng";
    changelog = "https://github.com/bdraco/aiohttp-zlib-ng/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
