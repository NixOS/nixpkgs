{ stdenv, fetchurl, buildPythonPackage, pep8, nose, unittest2, docutils
, blockdiag
}:

buildPythonPackage rec {
  name = "nwdiag-1.0.3";

  src = fetchurl {
    url = "mirror://pypi/n/nwdiag/${name}.tar.gz";
    sha256 = "0n7ary1fngxk8bk15vabc8fhnmxlh098piciwaviwn7l4a5q1zys";
  };

  buildInputs = [ pep8 nose unittest2 docutils ];

  propagatedBuildInputs = [ blockdiag ];

  # tests fail
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Generate network-diagram image from spec-text file (similar to Graphviz)";
    homepage = http://blockdiag.com/;
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bjornfor ];
  };
}
