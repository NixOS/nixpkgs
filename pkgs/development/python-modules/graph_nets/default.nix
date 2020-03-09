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
  version = "1.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "73e98a5930c6c7b609257ada2cf4523db70810343e0593bf0fa710b77e991933";
  };

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
