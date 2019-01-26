{ stdenv, fetchPypi, buildPythonPackage, pytest }:

buildPythonPackage rec {
  pname = "libtmux";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2b969b507c26d9db08b85be4808d75774b6418ecf5a0f61956f7a1da44519585";
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
