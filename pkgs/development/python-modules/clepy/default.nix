{ stdenv, buildPythonPackage, fetchPypi, decorator, mock, nose }:

buildPythonPackage rec {
  pname = "clepy";
  version = "0.3.23";
  name  = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14rbijbgkw3vxfbcdd1j4ff9qlk7drdd461bb4fznabjqvqd1r5d";
  };

  buildInputs = [ decorator nose mock ];
  # no tests in module causing this bug https://github.com/pypa/setuptools/issues/613
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://code.google.com/p/clepy/;
    description = "Utilities created by the Cleveland Python users group";
    license = licenses.bsd2;
  };
}
