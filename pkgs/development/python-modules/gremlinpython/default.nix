{ stdenv, lib, buildPythonPackage, fetchPypi, python, pythonOlder
, pytestrunner, pyhamcrest
, six, isodate, tornado, aenum
}:

buildPythonPackage rec {
  pname = "gremlinpython";
  version = "3.4.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08pgs51wcrzy5bhakzc4bj9adzfyk2qydna7qk686rgj685shvs2";
  };

  # nativeBuildInputs = [ cython ];
  # buildInputs = [ libev ];
  propagatedBuildInputs = [ pytestrunner six isodate tornado aenum ];
  #   ++ lib.optionals (pythonOlder "3.4") [ futures ];

  checkInputs = [ pyhamcrest ];
  doCheck = false; # Only builds tests with PyHamcrest < 2, but nixpkgs version is >= 2

  meta = with lib; {
    description = "Apache TinkerPop™ is a graph computing framework for both graph databases (OLTP) and graph analytic systems (OLAP). Gremlin is the graph traversal language of TinkerPop.";
    homepage = "http://tinkerpop.apache.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ turion ];
  };
}
