{stdenv, buildPythonPackage, fetchFromGitHub, numpy, pybind11}:

buildPythonPackage rec {
  pname = "fasttext";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = "fastText";
    rev = version;
    sha256 = "1fcrz648r2s80bf7vc0l371xillz5jk3ldaiv9jb7wnsyri831b4";
  };

  buildInputs = [ pybind11 ];

  propagatedBuildInputs = [ numpy ];

  preBuild = ''
    HOME=$TMPDIR
  '';

  meta = with stdenv.lib; {
    description = "Python module for text classification and representation learning";
    homepage = https://fasttext.cc/;
    license = licenses.mit;
    maintainers = with maintainers; [ danieldk ];
  };
}
