{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  numpy,

  cmake,
  gfortran,

  gitUpdater,
}:
buildPythonPackage rec {
  name = "bezier";
  version = "2024.6.20";
  src = fetchFromGitHub {
    owner = "dhermes";
    repo = "bezier";
    tag = version;
    hash = "sha256-TH3x6K5S3uV/K/5e+TXCSiJsyJE0tZ+8ZLc+i/x/fV8=";
  };

  build-system = [ setuptools ];

  dependencies = [ numpy ];

  env.BEZIER_INSTALL_PREFIX = stdenv.mkDerivation {
    name = "bezier-fortran-extension";
    inherit version;

    src = "${src}/src/fortran";

    nativeBuildInputs = [
      cmake
      gfortran
    ];
  };

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Helper for Bézier Curves, Triangles, and Higher Order Objects";
    homepage = "https://github.com/dhermes/bezier";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ WeetHet ];
  };
}
