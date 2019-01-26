{ stdenv, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "palettable";
  version = "3.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0685b223a236bb7e2a900ef7a855ccf9a4027361c8acf400f3b350ea51870f80";
  };

  checkInputs = [ pytest ];
 
  checkPhase = ''
    pytest 
  '';

  meta = with stdenv.lib; {
    description = "A library of color palettes";
    homepage = https://jiffyclub.github.io/palettable/;
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}

