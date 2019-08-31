{ stdenv, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "palettable";
  version = "3.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qp83l4mnwa9rb06m1d45i4691nkbqi82895ck4j6pirb825mz4c";
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

