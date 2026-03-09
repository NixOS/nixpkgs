{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  packaging,
  psutil,
  pybind11,
  einops,
  ninja,
  numpy,
  pandas,
  rocmPackages,
  torch,
}:
buildPythonPackage (finalAttrs: {
  pname = "amd-aiter";
  version = "0.1.11.post1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "aiter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9CCSmEw0kIoxERhtkKhBkaAGx42kCssH7IPjTgbg9LA=";
  };

  postPatch = ''
    rmdir 3rdparty/composable_kernel
    ln -sf ${rocmPackages.composable_kernel.src} 3rdparty/composable_kernel
    substituteInPlace pyproject.toml \
      --replace-fail '"flydsl==0.0.1.dev95158637"' ""
  '';

  env = {
    SETUPTOOLS_SCM_PRETEND_VERSION = finalAttrs.version;
    PREBUILD_KERNELS = "0";
    BUILD_TARGET = "rocm";
    ROCM_PATH = "${rocmPackages.clr}";
  };

  build-system = [
    setuptools
    setuptools-scm
    packaging
    psutil
    pybind11
    ninja
    pandas
  ];

  buildInputs = [ rocmPackages.clr ];

  nativeBuildInputs = [ rocmPackages.hipcc ];

  dependencies = [
    einops
    ninja
    numpy
    packaging
    pandas
    psutil
    pybind11
    torch
  ];

  pythonImportsCheck = [ "aiter" ];

  doCheck = false;

  meta = {
    description = "AI Tensor Engine for ROCm";
    homepage = "https://github.com/ROCm/aiter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lach ];
    platforms = lib.platforms.linux;
  };
})
