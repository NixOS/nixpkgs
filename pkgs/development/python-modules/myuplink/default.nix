{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "myuplink";
  version = "0.4.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pajzo";
    repo = "myuplink";
    rev = "refs/tags/${version}";
    hash = "sha256-zd1ZTLwgPD1m4SR5QVZWUvkjZtlB+VEfCZDsRELuYzE=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "%%VERSION_NO%%" "${version}"
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  pythonImportsCheck = [
    "myuplink"
  ];

  meta = with lib; {
    description = "Module to interact with the myUplink API";
    homepage = "https://github.com/pajzo/myuplink";
    changelog = "https://github.com/pajzo/myuplink/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
