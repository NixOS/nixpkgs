{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  ciso8601,
  fetchFromGitHub,
  orjson,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aiopyarr";
  version = "23.4.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "tkdrob";
    repo = "aiopyarr";
    tag = version;
    hash = "sha256-CzNB6ymvDTktiOGdcdCvWLVQ3mKmbdMpc/vezSXCpG4=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'version="master"' 'version="${version}"'
  '';

  propagatedBuildInputs = [
    aiohttp
    ciso8601
    orjson
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiopyarr" ];

  meta = {
    description = "Python API client for Lidarr/Radarr/Readarr/Sonarr";
    homepage = "https://github.com/tkdrob/aiopyarr";
    changelog = "https://github.com/tkdrob/aiopyarr/releases/tag/${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
