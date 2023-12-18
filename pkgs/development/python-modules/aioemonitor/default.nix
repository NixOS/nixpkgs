{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytest-raises
, pytestCheckHook
, pythonOlder
, xmltodict
}:

buildPythonPackage rec {
  pname = "aioemonitor";
  version = "1.0.5";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = pname;
    rev = "v${version}";
    sha256 = "0h8zqqy8v8r1fl9bp3m8icr2sy44p0mbfl1hbb0zni17r9r50dhn";
  };

  propagatedBuildInputs = [
    aiohttp
    xmltodict
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-raises
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py --replace '"pytest-runner>=5.2",' ""
  '';

  pythonImportsCheck = [ "aioemonitor" ];

  meta = with lib; {
    description = "Python client for SiteSage Emonitor";
    homepage = "https://github.com/bdraco/aioemonitor";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
