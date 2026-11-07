{
  lib,
  pkgs,
  buildPythonPackage,
  callPackage,
  fetchPypi,
  setuptools,
  cython,
  pkgconfig,
  passagemath-setup,
  passagemath-environment,
  cysignals,
  gmpy2,
  numpy,
  scipy,
  pillow,
  matplotlib,
  jupyter-threejs-sage,
  passagemath-categories,
  passagemath-modules,
  ...
}:
let
  memory-allocator = callPackage ../downgrades/memory-allocator { };
in
buildPythonPackage rec {
  pname = "passagemath-plot";
  version = "10.8.13";

  pyproject = true;
  build-system = [
    setuptools
    cython
    pkgconfig
    passagemath-setup
    passagemath-environment
  ];
  buildInputs = with pkgs; [
    libz
    gsl
  ];
  dependencies = [
    cysignals
    gmpy2
    memory-allocator
    numpy
    scipy
    pillow
    matplotlib
    jupyter-threejs-sage
    passagemath-categories
    passagemath-modules
  ];

  src = fetchPypi {
    pname = "passagemath_plot";
    inherit version;
    hash = "sha256-MM2Xu2cLB7RMsdFeqyMac5oQ/S3cjXPbW51Y/v33QvY=";
  };

  meta = {
    description = "passagemath: Plotting and graphics with Matplotlib, Three.JS, etc.";
    longDescription = ''
      `passagemath-plot` provides the `sage.plot` and `sage.plot.plot3d`
      namespace packages for two-dimensional and three-dimensional graphics,
      with plotting backends including Matplotlib and Three.js.
    '';
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl2Plus;
  };
}
