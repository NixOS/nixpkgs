{ stdenv, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "palettable";
  version = "3.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "72feca71cf7d79830cd6d9181b02edf227b867d503bec953cf9fa91bf44896bd";
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

