{
  lib,
  aiohttp,
  apispec,
  buildPythonPackage,
  fetchFromGitHub,
  jinja2,
  packaging,
  pytest-aiohttp,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  webargs,
}:

buildPythonPackage rec {
  pname = "aiohttp-apispec";
  version = "3.0.0b2";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "maximdanilchenko";
    repo = "aiohttp-apispec";
    tag = "v${version}";
    hash = "sha256-C+/M25oCLTNGGEUj2EyXn3UjcvPvDYFmmUW8IOoF1uU=";
  };

  doCheck = false;

  /*
    postPatch = ''
      substituteInPlace tests/conftest.py \
        --replace-fail 'aiohttp_app(loop,' 'aiohttp_app(event_loop,' \
        --replace-fail 'return loop.run_until_complete' 'return event_loop.run_until_complete'
    '';
  */

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    apispec
    jinja2
    packaging
    webargs
  ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiohttp_apispec" ];

  meta = with lib; {
    description = "Build and document REST APIs with aiohttp and apispec";
    homepage = "https://github.com/maximdanilchenko/aiohttp-apispec/";
    license = licenses.mit;
    maintainers = [ ];
  };
}
