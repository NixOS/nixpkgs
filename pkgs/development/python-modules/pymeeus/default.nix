{ stdenv, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "PyMeeus";
  version = "0.3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qjnk9sc65i4by2x4zm6w941a4i31fmhgwbkpbqkk87rwq4h4hsn";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    pytest .
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/architest/pymeeus";
    description = "Library of astronomical algorithms";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ jluttine ];
  };
}
