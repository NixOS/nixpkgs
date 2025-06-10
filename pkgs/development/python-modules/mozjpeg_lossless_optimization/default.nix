{
  lib,
  python3Packages,
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
  pname = "mozjpeg_lossless_optimization";
  version = "1.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wanadev";
    repo = "mozjpeg-lossless-optimization";
    # https://github.com/NixOS/nixpkgs/issues/26302
    rev = "refs/tags/v${version}";
    hash = "sha256-OKNt9XtfZ6hhRJN1Asn1T2dVjyXKQAsnFvXKYnrRZ98=";
    fetchSubmodules = true;
  };

  # This package needs cmake, but it is not the default builder
  dontUseCmakeConfigure = true;

  buildInputs = [ mozjpeg ];
  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ cffi ];

  # https://github.com/NixOS/nixpkgs/issues/255262
  preCheck = ''
    rm -r mozjpeg_lossless_optimization
  '';

  build-system = [ setuptools ];
  nativeCheckInputs = [ pytestCheckHook ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Python library to optimize JPEGs losslessly using MozJPEG";
    homepage = "https://github.com/wanadev/mozjpeg-lossless-optimization";
    changelog = "https://github.com/wanadev/mozjpeg-lossless-optimization/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.adfaure ];
  };
}
