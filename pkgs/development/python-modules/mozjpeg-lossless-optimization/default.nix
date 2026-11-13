{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  mozjpeg,
  pytestCheckHook,
  setuptools,
  cmake,
  nix-update-script,
  cffi,
}:
buildPythonPackage rec {
  pname = "mozjpeg-lossless-optimization";
  version = "1.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wanadev";
    repo = "mozjpeg-lossless-optimization";
    tag = "v${version}";
    hash = "sha256-0w0e7QbYi3W6MahY8fnI+dYkQHqheOXQn3mJN/UfHlk=";
    fetchSubmodules = true;
  };

  # This package needs cmake, but it is not the default builder
  dontUseCmakeConfigure = true;

  build-system = [
    cffi
    cmake
    setuptools
  ];

  dependencies = [ cffi ];

  # https://github.com/NixOS/nixpkgs/issues/255262
  preCheck = ''
    rm -r mozjpeg_lossless_optimization
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mozjpeg_lossless_optimization" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Python library to optimize JPEGs losslessly using MozJPEG";
    homepage = "https://github.com/wanadev/mozjpeg-lossless-optimization";
    changelog = "https://github.com/wanadev/mozjpeg-lossless-optimization/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.adfaure ];
  };
}
