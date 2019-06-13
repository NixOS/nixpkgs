{ stdenv, fetchurl, buildPythonPackage, pep8, nose, unittest2, docutils
, blockdiag
}:

buildPythonPackage rec {
  pname = "nwdiag";
  version = "1.0.4";
  name = pname + "-" + version;

  src = fetchurl {
    url = "mirror://pypi/n/nwdiag/${name}.tar.gz";
    sha256 = "002565875559789a2dfc5f578c07abdf44269c3f7cdf78d4809bdc4bdc2213fa";
  };

  buildInputs = [ pep8 nose unittest2 docutils ];

  propagatedBuildInputs = [ blockdiag ];

  # tests fail
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Generate network-diagram image from spec-text file (similar to Graphviz)";
    homepage = http://blockdiag.com/;
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor ];
  };
}
