{ stdenv, fetchPypi, buildPythonPackage, pytest }:

buildPythonPackage rec {
  pname = "libtmux";
  version = "0.8.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a4c7379604ccdc684aa865723211184709f9a2b45511772989b5f26ad156650e";
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
