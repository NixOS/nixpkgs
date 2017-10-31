{ stdenv, buildPythonPackage, fetchPypi, pytest, pytestrunner, wcwidth }:

buildPythonPackage rec {
  pname = "pyte";
  version = "0.7.0";
  name  = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1an54hvyjm8gncx8cgabz9mkpgjkdb0bkyjlkh7g7f94nr3wnfl7";
  };

  propagatedBuildInputs = [ wcwidth ];

  checkInputs = [ pytest pytestrunner ];

  # tries to write to os.path.dirname(__file__) in test_input_output
  checkPhase = ''
    py.test -k "not test_input_output"
  '';

  meta = with stdenv.lib; {
    description = "Simple VTXXX-compatible linux terminal emulator";
    homepage = https://github.com/selectel/pyte;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ flokli ];
  };
}
