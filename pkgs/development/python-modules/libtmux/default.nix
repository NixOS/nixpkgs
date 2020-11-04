{ stdenv, fetchPypi, buildPythonPackage, pytest }:

buildPythonPackage rec {
  pname = "libtmux";
  version = "0.8.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d35b9f8451944d31c5ed22ed9e6c8e18034adcc75718fcc5b27fbd9621543e1";
  };

  checkInputs = [ pytest ];
  postPatch = ''
    sed -i 's/==.*$//' requirements/test.txt
  '';

  # No tests in archive
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Scripting library for tmux";
    homepage = "https://libtmux.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
