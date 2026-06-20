{
  gcc,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cffi,
  pkg-config,
  glfw3,
  libffi,
  raylib,
  physac,
  raygui,
  lib,
  writers,
}:

buildPythonPackage (finalAttrs: {
  pname = "raylib-python-cffi";
  version = "6.0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "electronstudio";
    repo = "raylib-python-cffi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9eN3H62gYDloMHbJbTFiO3acif3GJuTkk4CWltzBOXg=";
  };

  build-system = [ setuptools ];
  dependencies = [ cffi ];

  patches = [ ./use-direct-pkg-config-name.patch ];

  buildInputs = [
    glfw3
    libffi
    raylib
    physac
    raygui
  ];

  nativeBuildInputs = [
    pkg-config
    gcc
  ];

  # tests require a graphic environment
  doCheck = false;

  pythonImportsCheck = [ "pyray" ];

  passthru.tests = import ./passthru-tests.nix {
    inherit writers;
    raylib-python-cffi = finalAttrs.finalPackage;
  };

  meta = {
    description = "Python CFFI bindings for Raylib";
    homepage = "https://electronstudio.github.io/raylib-python-cffi";
    license = lib.licenses.epl20;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
})
