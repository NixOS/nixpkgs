{
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cffi,
  pkg-config,
  glfw,
  libffi,
  raylib,
  physac,
  raygui,
  lib
}:

buildPythonPackage rec {
  pname = "raylib-python-cffi";
  version = "5.0.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "electronstudio";
    repo = "raylib-python-cffi";
    rev = "refs/tags/v${version}";
    hash = "sha256-DlnZRJZ0ZnkLii09grA/lGsJHPUYrbaJ55BVWJ8JzfM=";
  };

  build-system = [ setuptools ];
  dependencies = [ cffi ];

  patches = [
    # This patch fixes to the builder script function to call pkg-config
    # using the library name rather than searching only through raylib
    ./fix_pyray_builder.patch
  ];

  nativeBuildInputs = [ pkg-config ];

  # tests require a graphic environment
  doCheck = false;

  pythonImportsCheck = [ "pyray" ];

  buildInputs = [
    glfw
    libffi
    raylib
    physac
    raygui
  ];

  meta = {
    description = "Python CFFI bindings for Raylib";
    homepage = "https://electronstudio.github.io/raylib-python-cffi";
    license = lib.licenses.epl20;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
