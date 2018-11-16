{ stdenv, buildPythonPackage, fetchPypi, pytest, pytestrunner, wcwidth }:

buildPythonPackage rec {
  pname = "pyte";
  version = "0.8.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "7e71d03e972d6f262cbe8704ff70039855f05ee6f7ad9d7129df9c977b5a88c5";
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
