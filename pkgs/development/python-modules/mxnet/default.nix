{ lib
, buildPythonPackage
, pkgs
, requests
, numpy
, graphviz
, python
, isPy3k
}:

buildPythonPackage {
  inherit (pkgs.mxnet) pname version src meta;

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

}
