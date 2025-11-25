{
  lib,
  buildPythonPackage,
  distutils,
  graphviz,
  numpy,
  pkgs,
  python,
  requests,
  setuptools,
}:

buildPythonPackage {
  inherit (pkgs.mxnet) pname version src;
  pyproject = true;

  build-system = [ setuptools ];

  buildInputs = [ pkgs.mxnet ];

  dependencies = [
    distutils
    graphviz
    numpy
    requests
  ];

  pythonRelaxDeps = [
    "graphviz"
    "numpy"
  ];

  LD_LIBRARY_PATH = lib.makeLibraryPath [ pkgs.mxnet ];

  postPatch = ''
    # Required to support numpy >=1.24 where np.bool is removed in favor of just bool
    substituteInPlace python/mxnet/numpy/utils.py \
      --replace-fail "bool = onp.bool" "bool = bool"
  '';

  preConfigure = ''
    cd python
  '';

  postInstall = ''
    rm -rf $out/mxnet
    ln -s ${pkgs.mxnet}/lib/libmxnet.so $out/${python.sitePackages}/mxnet
  '';

  meta = pkgs.mxnet.meta;
}
