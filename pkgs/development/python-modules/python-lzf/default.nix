{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  version = "0.2.4";
  pname = "python-lzf";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1l8m6vzwm1m8hn7ldw8j8r2b6r199k8z3q0wnhdyy4p68hahyhni";
  };

  meta = with stdenv.lib; {
    description = "liblzf python bindings";
    homepage = https://github.com/teepark/python-lzf;
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
