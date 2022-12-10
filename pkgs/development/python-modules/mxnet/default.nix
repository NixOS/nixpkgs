{ lib
, buildPythonPackage
, pkgs
, requests
, numpy
, graphviz
, python
, isPy3k
, isPy310
}:

buildPythonPackage {
  inherit (pkgs.mxnet) pname version src;

  buildInputs = [ pkgs.mxnet ];
  propagatedBuildInputs = [ requests numpy graphviz ];

  LD_LIBRARY_PATH = lib.makeLibraryPath [ pkgs.mxnet ];

  doCheck = !isPy3k;

  postPatch = ''
    substituteInPlace python/setup.py \
      --replace "graphviz<0.9.0," "graphviz"
  '';

  preConfigure = ''
    cd python
  '';

  postInstall = ''
    rm -rf $out/mxnet
    ln -s ${pkgs.mxnet}/lib/libmxnet.so $out/${python.sitePackages}/mxnet
  '';

  meta = pkgs.mxnet.meta // {
    broken = (pkgs.mxnet.broken or false) || (isPy310 && pkgs.mxnet.cudaSupport);
  };
}
