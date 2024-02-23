{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "myuplink";
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pajzo";
    repo = "myuplink";
    rev = "refs/tags/${version}";
    hash = "sha256-xITV5+d/9j8pjfvmnt8RfGHu4lfLu8cMFV0MzURy6hA=";
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
