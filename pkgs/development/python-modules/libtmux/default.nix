{ stdenv, fetchPypi, buildPythonPackage, pytest }:

buildPythonPackage rec {
  pname = "libtmux";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0al5qcvzcl4v70vngbv39jg422jsy0m1b5q9pp54cc7m9b666jax";
  };

  checkInputs = [ pytest ];
  postPatch = ''
    sed -i 's/==.*$//' requirements/test.txt
  '';

  # No tests in archive
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Scripting library for tmux";
    homepage = https://libtmux.readthedocs.io/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ jgeerds ];
  };
}
