{
  buildPythonPackage,
  click,
  distlib,
  fetchFromGitHub,
  jinja2,
  lark,
  lib,
  nox,
  packaging,
  pkgsHostTarget,
  pyproject-metadata,
  pytestCheckHook,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "py-build-cmake";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tttapa";
    repo = "py-build-cmake";
    tag = finalAttrs.version;
    hash = "sha256-Dhrj0REtZJKXA6dufgXyuGReMyhd5sU9ExKCZbZavrE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail 'pyproject-metadata~=0.9.1' 'pyproject-metadata'

    # Don't expect cmake to be on the PATH
    substituteInPlace src/py_build_cmake/{build.py,commands/cmake.py} \
      --replace-fail 'Path("cmake")' 'Path("${lib.getExe pkgsHostTarget.cmake}")'
    substituteInPlace src/py_build_cmake/commands/try_run.py \
      --replace-fail 'check_program_version("cmake"' 'check_program_version("${lib.getExe pkgsHostTarget.cmake}"'
  '';

  build-system = [
    distlib
    lark
    packaging
    pyproject-metadata
  ];

  dependencies = [
    click
    distlib
    lark
    packaging
    pyproject-metadata
  ];

  nativeCheckInputs = [
    jinja2
    nox
    pytestCheckHook
    versionCheckHook
  ];

  pythonImportsCheck = [ "py_build_cmake" ];

  meta = {
    description = "PEP 517 build backend for Python packages with extensions built with CMake";
    homepage = "https://github.com/tttapa/py-build-cmake";
    mainProgram = "py-build-cmake";
    maintainers = with lib.maintainers; [ mdaniels5757 ];
    license = lib.licenses.mit;
  };
})
