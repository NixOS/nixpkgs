{ stdenv, fetchPypi, buildPythonPackage, pytest_29 }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "libtmux";
  version = "0.7.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12e5006e59b7d98af5d1a9294f9c8ff2829ac2c1c6ae23dc73c280100b15f485";
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

