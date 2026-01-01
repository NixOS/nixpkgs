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
<<<<<<< HEAD
  version = "5.5.0.4";
=======
  version = "5.5.0.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "electronstudio";
    repo = "raylib-python-cffi";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-MKyTpGnup4QmRui2OVBpnyn9KENATWcwYcikOmYX4c8=";
=======
    hash = "sha256-VsdUOk26xXEwha7kGYHy4Cgwrr3yOiSlJg4nYn+ZYYs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
