{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "yocto-cooker";
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cpb-";
    repo = "yocto-cooker";
    tag = finalAttrs.version;
    hash = "sha256-Ft9mugieVTYQv0rXohnsfX3AJlrgg12JNP/N7cLSdmw=";
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

  meta = {
    description = "Meta buildtool for Yocto Project based Linux embedded systems";
    homepage = "https://github.com/cpb-/yocto-cooker";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ aiyion ];
    mainProgram = "cooker";
  };
})
