{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "aiohttp-wsgi";
  version = "0.10.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "etianen";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-3Q00FidZWV1KueuHyHKQf1PsDJGOaRW6v/kBy7lzD4Q=";
  };

  propagatedBuildInputs = [ aiohttp ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "aiohttp_wsgi" ];

  meta = with lib; {
    description = "WSGI adapter for aiohttp";
    mainProgram = "aiohttp-wsgi-serve";
    homepage = "https://github.com/etianen/aiohttp-wsgi";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
