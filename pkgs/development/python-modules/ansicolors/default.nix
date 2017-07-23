{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "ansicolors";
  version = "1.0.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02lmh2fbqcwr98cq13l9ql0fvyad1dcb3ap3c5xq9qwjp45m6r3n";
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/verigak/colors/";
    description = "ANSI colors for Python";
    license = licenses.isc;
    maintainers = with maintainers; [ copumpkin ];
  };
}
