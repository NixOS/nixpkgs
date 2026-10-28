{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  poetry-core,
  pytest7CheckHook,
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

  patches = [
    (fetchpatch {
      name = "setuptools-82-compat.patch";
      url = "https://github.com/efficios/barectf/commit/e16d289546bb4f6b0d909f79b8d6188eabe32640.patch";
      hash = "sha256-5tSOxc6trSHFPnVj+7YVO9J65bZ1H2MFKrZAbRy1WTM=";
      excludes = [
        "pyproject.toml"
        "poetry.lock"
      ];
    })
  ];

  nativeBuildInputs = [
    poetry-core
  ];

  pythonRelaxDeps = [
    "jsonschema"
    "pyyaml"
    "termcolor"
  ];

  pythonRemoveDeps = [
    "setuptools"
  ];

  propagatedBuildInputs = [
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
