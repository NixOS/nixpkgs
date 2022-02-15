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
  version = "3.0.0b1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "maximdanilchenko";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-LGdi5ZhJ1G0GxUJVBZnwW3Q+x3Yo9FRV9b6REPlq7As=";
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

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "jinja2<3.0" "jinja2"
  '';

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
