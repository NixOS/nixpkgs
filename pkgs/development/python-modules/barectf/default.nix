{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest7CheckHook,
  setuptools,
  jsonschema,
  pyyaml,
  jinja2,
  termcolor,
}:

buildPythonPackage rec {
  pname = "barectf";
  version = "3.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "efficios";
    repo = "barectf";
    rev = "v${version}";
    hash = "sha256-JelFfd3WS012dveNlIljhLdyPmgE9VEOXoZE3MBA/Gw=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  pythonRelaxDeps = [
    "jsonschema"
    "pyyaml"
    "termcolor"
  ];

  propagatedBuildInputs = [
    setuptools # needs pkg_resources at runtime
    jsonschema
    pyyaml
    jinja2
    termcolor
  ];

  pythonImportsCheck = [ "barectf" ];

  nativeCheckInputs = [ pytest7CheckHook ];

  meta = {
    description = "Generator of ANSI C tracers which output CTF data streams";
    mainProgram = "barectf";
    homepage = "https://github.com/efficios/barectf";
    license = lib.licenses.mit;
  };
}
