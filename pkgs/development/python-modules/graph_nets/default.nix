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
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "278a040674bef295aaf8bb5b0d1b3f207144dc68f0bcfe3f14912b9b85eb0927";
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
    homepage = "https://github.com/deepmind/graph_nets";
    license = licenses.asl20;
    maintainers = with maintainers; [ timokau ];
    broken = true;
  };
}
