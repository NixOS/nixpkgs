{ lib, buildPythonPackage, fetchPypi, py, pytest }:

buildPythonPackage rec {
  pname = "pytest-datafiles";
  version = "2.0";
  src = fetchPypi {
    inherit version pname;
    sha256 = "1yfvaqbqvjfikz215kwn6qiwwn9girka93zq4jphgfyvn75jjcql";
  };

  buildInputs = [ py pytest ];

  meta = with lib; {
    license = licenses.mit;
    homepage = "https://github.com/omarkohl/pytest-datafiles";
    description = "py.test plugin to create a 'tmpdir' containing predefined files/directories.";
  };
}
