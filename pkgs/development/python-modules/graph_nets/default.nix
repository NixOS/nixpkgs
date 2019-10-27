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
  version = "1.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6f27f0358a477d4ec3ab300bf09944b4dfdd5c10b0a5f7ac06bcb32d1327ebe1";
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
