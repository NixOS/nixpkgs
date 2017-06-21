{ stdenv, buildPythonPackage, fetchPypi, graphviz
, pkgconfig, doctest-ignore-unicode, mock, nose }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "pygraphviz";
  version = "1.4rc1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00ck696rddjnrwfnh1zw87b9xzqfm6sqjy6kqf6kmn1xwsi6f19a";
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
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
