{ stdenv, fetchPypi, buildPythonPackage, pytest_29 }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "libtmux";
  version = "0.7.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "111qbgq28za12la5b0aa9rr7hg8235zy0kyzzryn7fa6z3i5k5z8";
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

