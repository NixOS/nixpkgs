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
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "aiopyarr";
  version = "23.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "tkdrob";
    repo = pname;
    rev = "refs/tags/${version}";
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

  meta = with lib; {
    description = "Python API client for Lidarr/Radarr/Readarr/Sonarr";
    homepage = "https://github.com/tkdrob/aiopyarr";
    changelog = "https://github.com/tkdrob/aiopyarr/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
