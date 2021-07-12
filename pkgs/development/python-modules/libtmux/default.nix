{ lib, fetchPypi, buildPythonPackage, pytest }:

buildPythonPackage rec {
  pname = "libtmux";
  version = "0.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c8bc81499616ba899538704e419463a1c83ba7ca21e53b1efc6abbe98eb26b61";
  };

  checkInputs = [ pytest ];
  postPatch = ''
    sed -i 's/==.*$//' requirements/test.txt
  '';

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    description = "Scripting library for tmux";
    homepage = "https://libtmux.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
