{ lib
, aiohttp
, buildPythonPackage
, callPackage
, fetchFromGitHub
, fetchPypi
, pythonOlder
, webargs
}:

buildPythonPackage rec {
  pname = "aiohttp-apispec";
  version = "2.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "maximdanilchenko";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-51QyD56k+1fq2tOqBNUtPRFza9uku79GcvTh8wov04g=";
  };

  propagatedBuildInputs = [
    aiohttp
    apispec3
    jinja2
    webargs
  ];

  pythonImportsCheck = [
    "aiohttp_apispec"
  ];

  # Requires pytest-sanic, currently broken in nixpkgs
  doCheck = false;

  meta = with lib; {
    description = "Build and document REST APIs with aiohttp and apispec";
    homepage = "https://github.com/maximdanilchenko/aiohttp-apispec/";
    license = licenses.mit;
    maintainers = with maintainers; [ viric ];
  };
}
