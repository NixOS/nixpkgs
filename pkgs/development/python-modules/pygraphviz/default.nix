{ stdenv, buildPythonPackage, isPy3k, fetchPypi, substituteAll, graphviz
, pkgconfig, doctest-ignore-unicode, mock, nose }:

buildPythonPackage rec {
  pname = "pygraphviz";
  version = "1.6";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "411ae84a5bc313e3e1523a1cace59159f512336318a510573b47f824edef8860";
    extension = "zip";
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
    homepage = "https://github.com/pygraphviz/pygraphviz";
    license = licenses.bsd3;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
