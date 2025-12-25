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
  raylib-python-cffi,
}:

buildPythonPackage rec {
  pname = "raylib-python-cffi";
  version = "5.6.0.0.dev3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "electronstudio";
    repo = "raylib-python-cffi";
    tag = "v${version}";
    hash = "sha256-Qar1H2YhQiO/817rCehLfBGx3Y0ErDKNjU3Wp9gQVyE=";
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
    inherit src raylib-python-cffi writers;
  };

  meta = {
    description = "Python CFFI bindings for Raylib";
    homepage = "https://electronstudio.github.io/raylib-python-cffi";
    license = lib.licenses.epl20;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
