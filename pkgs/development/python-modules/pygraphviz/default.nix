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

  # the tests are currently failing:
  # check status of pygraphviz/pygraphviz#129
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python interface to Graphviz graph drawing package";
    homepage = https://github.com/pygraphviz/pygraphviz;
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
