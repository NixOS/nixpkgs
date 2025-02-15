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
  version = "5.5.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "electronstudio";
    repo = "raylib-python-cffi";
    tag = "v${version}";
    hash = "sha256-Ls+9+iByGQJQJdJiW4WOmKPGbrWJDisXZ1ZYqvAj+3o=";
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
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
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
