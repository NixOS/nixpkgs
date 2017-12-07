{ stdenv, fetchPypi, buildPythonPackage, pytest_29 }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "libtmux";
  version = "0.7.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5670c8da8d0192d932ac1e34f010e0eeb098cdb2af6daad0307b5418e7a37733";
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

