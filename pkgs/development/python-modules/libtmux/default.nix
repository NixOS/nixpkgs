{ lib, fetchPypi, buildPythonPackage, pytest }:

buildPythonPackage rec {
  pname = "libtmux";
  version = "0.10.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a0e958b85ec14cdaabecfa738a0dd51846f05e5c5e9d6749a2bf5160b9f7e1d2";
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
