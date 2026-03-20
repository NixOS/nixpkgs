{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-raises,
  pytestCheckHook,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "aioemonitor";
  version = "1.0.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "aioemonitor";
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

  meta = {
    description = "Python client for SiteSage Emonitor";
    mainProgram = "my_example";
    homepage = "https://github.com/bdraco/aioemonitor";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
