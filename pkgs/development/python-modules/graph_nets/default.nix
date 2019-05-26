{ lib
, buildPythonPackage
, fetchPypi
, tensorflow
, absl-py
, dm-sonnet
, networkx
, numpy
, setuptools
, six
, future
}:

buildPythonPackage rec {
  pname = "graph_nets";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15cbs9smmgqz2n9mnlzdbqj3iv9iw179d2g0f9lnimdy7xl4jqdf";
  };

  buildInputs = [];

  postPatch = ''
    # https://github.com/deepmind/graph_nets/issues/63
    sed -i 's/dm-sonnet==1.23/dm-sonnet/' setup.py
  '';

  propagatedBuildInputs = [
    tensorflow
    absl-py
    dm-sonnet
    networkx
    numpy
    setuptools
    six
    future
  ];

  meta = with lib; {
    description = "Build Graph Nets in Tensorflow";
    homepage = https://github.com/deepmind/graph_nets;
    license = licenses.asl20;
    maintainers = with maintainers; [ timokau ];
  };
}
