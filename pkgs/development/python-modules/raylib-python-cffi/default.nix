{
  stdenv,
  gcc,
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
  darwin,
  lib,
}:

let
  inherit (darwin.apple_sdk.frameworks)
    OpenGL
    Cocoa
    IOKit
    CoreFoundation
    CoreVideo
    ;
in
buildPythonPackage rec {
  pname = "raylib-python-cffi";
  version = "5.0.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "electronstudio";
    repo = "raylib-python-cffi";
    rev = "refs/tags/v${version}";
    hash = "sha256-R/w39zYkoOF5JqHDyqVIdON9yXFo2PeosyEQZOd4aYo=";
  };

  build-system = [ setuptools ];
  dependencies = [ cffi ];

  patches = [
    # This patch fixes to the builder script function to call pkg-config
    # using the library name rather than searching only through raylib
    ./fix_pyray_builder.patch

    # use get_lib_flags() instead of linking to libraylib.a directly
    ./fix_macos_raylib.patch
  ];

  nativeBuildInputs = [
    pkg-config
    gcc
  ];

  # tests require a graphic environment
  doCheck = false;

  pythonImportsCheck = [ "pyray" ];

  buildInputs =
    [
      glfw
      libffi
      raylib
      physac
      raygui
    ]
    ++ lib.optionals stdenv.isDarwin [
      OpenGL
      Cocoa
      IOKit
      CoreFoundation
      CoreVideo
    ];

  meta = {
    description = "Python CFFI bindings for Raylib";
    homepage = "https://electronstudio.github.io/raylib-python-cffi";
    license = lib.licenses.epl20;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
