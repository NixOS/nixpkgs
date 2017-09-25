{ stdenv, fetchPypi, buildPythonPackage, pytest_29 }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "libtmux";
  version = "0.7.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c7407aa4103d40f50f99432bf4dffe0b4591f976956b2dd7ee7bbf53ad138bd9";
  };

  buildInputs = [ pytest_29 ];
  patchPhase = ''
    sed -i 's/==.*$//' requirements/test.txt
  '';

  meta = with stdenv.lib; {
    description = "Scripting library for tmux";
    homepage = https://libtmux.readthedocs.io/;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jgeerds ];
  };
}

