{
  lib,
  buildPythonPackage,
  capstone,
  cmake,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  comfyui,
}:

let
  funchookVersion = "1.1.3";
  funchook = fetchFromGitHub {
    owner = "kubo";
    repo = "funchook";
    tag = "v${funchookVersion}";
    fetchSubmodules = true;
    hash = "sha256-u/RXMNyKL6L7p5gEFnAQTErPXXGKXv74jbYlBbG0Wy4=";
  };
in
buildPythonPackage (finalAttrs: {
  pname = "comfy-aimdo";
  version = "0.4.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Comfy-Org";
    repo = "comfy-aimdo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cIgvOC4Ocv3JiAdVMUGjX4cv+bGFkaiw65PRi0ys2ig=";
  };

  postPatch = ''
    chmod +x scripts/*.sh
    patchShebangs scripts/*.sh

    substituteInPlace scripts/build-linux-aimdo.sh \
      --replace-fail '-j"$(getconf _NPROCESSORS_ONLN 2>/dev/null || echo 1)"' '-j$NIX_BUILD_CORES'

    mkdir build
    cp -r ${funchook} build/funchook-${funchookVersion}

    mkdir -p build/funchook-${funchookVersion}-capstone
    cp -r ${capstone.src} build/funchook-${funchookVersion}-capstone/capstone-src

    chmod -R +w build
  '';

  nativeBuildInputs = [
    cmake
  ];

  dontUseCmakeConfigure = true;

  build-system = [
    setuptools
    setuptools-scm
  ];

  preBuild = ''
    ./scripts/build-linux-aimdo.sh
  '';

  # Upstream ships no test suite at this tag.
  doCheck = false;

  pythonImportsCheck = [ "comfy_aimdo" ];

  meta = {
    description = "AI model dynamic offloader for ComfyUI";
    homepage = "https://github.com/Comfy-Org/comfy-aimdo";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    inherit (comfyui.meta) maintainers;
  };
})
