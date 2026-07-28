{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "yocto-cooker";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cpb-";
    repo = "yocto-cooker";
    tag = finalAttrs.version;
    hash = "sha256-h4fmpYzErOiu5M7XHuqlRUvDpXUoOC0c/HGs9a5PZNg=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    jsonschema
    urllib3
    pyjson5
  ];

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    description = "Meta buildtool for Yocto Project based Linux embedded systems";
    homepage = "https://github.com/cpb-/yocto-cooker";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ aiyion ];
    mainProgram = "cooker";
  };
})
