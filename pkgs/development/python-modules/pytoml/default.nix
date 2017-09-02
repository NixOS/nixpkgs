{ stdenv, buildPythonPackage, fetchgit
, python }:

buildPythonPackage rec {
  pname = "pytoml";
  version = "0.1.11";
  name = "${pname}-${version}";

  checkPhase = "${python.interpreter} test/test.py";

  # fetchgit used to ensure test submodule is available
  src = fetchgit {
    url = "${meta.homepage}.git";
    rev = "refs/tags/v${version}";
    sha256 = "1jiw04zk9ccynr8kb1vqh9r1p2kh0al7g7b1f94911iazg7dgs9j";
  };

  meta = with stdenv.lib; {
    description = "A TOML parser/writer for Python";
    homepage    = https://github.com/avakar/pytoml;
    license     = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
