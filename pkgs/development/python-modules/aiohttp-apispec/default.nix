{ lib
, aiohttp
, apispec
, buildPythonPackage
, callPackage
, fetchFromGitHub
, fetchPypi
, jinja2
, packaging
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
, webargs
}:

buildPythonPackage rec {
  pname = "aiohttp-apispec";
  version = "3.0.0b2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "maximdanilchenko";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-C+/M25oCLTNGGEUj2EyXn3UjcvPvDYFmmUW8IOoF1uU=";
  };

  propagatedBuildInputs = [
    aiohttp
    apispec
    jinja2
    packaging
    webargs
  ];

  checkInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aiohttp_apispec"
  ];

  meta = with lib; {
    description = "Build and document REST APIs with aiohttp and apispec";
    homepage = "https://github.com/maximdanilchenko/aiohttp-apispec/";
    license = licenses.mit;
    maintainers = with maintainers; [ viric ];
  };
}
