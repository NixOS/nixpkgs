{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, iso4217
, pytest-asyncio
, pythonOlder
, pytz
}:

buildPythonPackage rec {
  pname = "pyefergy";
  version = "22.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "tkdrob";
    repo = pname;
    rev = version;
    hash = "sha256-AdoM+PcVoajxhnEfkyN9UuNufChu8XGmZDLNC3mjrps=";
  };

  postPatch = ''
    # setuptools.extern.packaging.version.InvalidVersion: Invalid version: 'master'
    substituteInPlace setup.py \
      --replace 'version="master",' 'version="${version}",'
  '';

  propagatedBuildInputs = [
    aiohttp
    iso4217
    pytz
  ];

  # Tests require network access
  doCheck  =false;

  pythonImportsCheck = [
    "pyefergy"
  ];

  meta = with lib; {
    description = "Python API library for Efergy energy meters";
    homepage = "https://github.com/tkdrob/pyefergy";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
