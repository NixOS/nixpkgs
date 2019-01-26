{ stdenv, buildPythonPackage, fetchPypi, graphviz
, pkgconfig, doctest-ignore-unicode, mock, nose }:

buildPythonPackage rec {
  pname = "pygraphviz";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7c294cbc9d88946be671cc0d8602aac176d8c56695c0a7d871eadea75a958408";
  };

  buildInputs = [ doctest-ignore-unicode mock nose ];
  propagatedBuildInputs = [ graphviz pkgconfig ];

  patches = [
    # pygraphviz depends on graphviz being in PATH. This patch always prepends
    # graphviz to PATH.
    ./graphviz-path.patch
  ];
  postPatch = ''
    substituteInPlace pygraphviz/agraph.py --subst-var-by graphvizPath '${graphviz}/bin'
  '';

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
