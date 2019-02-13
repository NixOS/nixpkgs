{ stdenv, buildPythonPackage, fetchPypi, substituteAll, graphviz
, pkgconfig, doctest-ignore-unicode, mock, nose }:

buildPythonPackage rec {
  pname = "pygraphviz";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7c294cbc9d88946be671cc0d8602aac176d8c56695c0a7d871eadea75a958408";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ graphviz ];
  checkInputs = [ doctest-ignore-unicode mock nose ];

  patches = [
    # pygraphviz depends on graphviz being in PATH. This patch always prepends
    # graphviz to PATH.
    (substituteAll {
      src = ./graphviz-path.patch;
      inherit graphviz;
    })
  ];

  # The tests are currently failing because of a bug in graphviz 2.40.1.
  # Upstream does not want to skip the relevant tests:
  # https://github.com/pygraphviz/pygraphviz/pull/129
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python interface to Graphviz graph drawing package";
    homepage = https://github.com/pygraphviz/pygraphviz;
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
