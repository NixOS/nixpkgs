{ stdenv
, buildPythonPackage
, fetchgit
, python
}:

buildPythonPackage rec {
  pname = "pytoml";
  version = "0.1.14";

  checkPhase = ''
    ${python.interpreter} test/test.py
  '';

  # fetchgit used to ensure test submodule is available
  src = fetchgit {
    url = "${meta.homepage}.git";
    rev = "refs/tags/v${version}";
    sha256 = "1ip71yqxnyi4jhw5x1q7a0za61ndhpfh0vbx08jfv0w4ayng6rgv";
  };

  meta = with stdenv.lib; {
    description = "A TOML parser/writer for Python";
    homepage    = https://github.com/avakar/pytoml;
    license     = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
