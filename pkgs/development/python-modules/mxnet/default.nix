{ stdenv
, lib
, buildPythonPackage
, requests
, numpy
, graphviz
, onnx
, mxnet
, python
, isPy3k
}:

buildPythonPackage rec {
  inherit (mxnet) name version src meta;

  propagatedBuildInputs = [ mxnet requests numpy graphviz onnx ];

  LD_LIBRARY_PATH = lib.makeLibraryPath [ mxnet ];

  sourceRoot = "python";

  # NOTE: We weaken requests requirenments to avoid backporting to
  # requests-2.18. Newer version should not cause problems, according the
  # changelog. See https://github.com/requests/requests/blob/master/HISTORY.rst
  postPatch = ''
    sed -i 's/requests<2.19.0,>=2.18.4/requests<2.20.0,>=2.18.4/g' setup.py
  '';

  postInstall = ''
    rm -rf $out/mxnet
    ln -s ${mxnet}/lib/libmxnet.so $out/${python.sitePackages}/mxnet
  '';
}
