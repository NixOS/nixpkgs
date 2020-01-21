{ lib, buildPythonPackage, fetchPypi, lark-parser, python, six }:

buildPythonPackage rec {
  pname = "commentjson";
  version = "0.8.2";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "db57d6e219140dd7ff2b8bc11a83cca73b317a0ae82d3d447814ed16fd4d2b55";
  };
  
  propagatedBuildInputs = [ lark-parser ];

  checkInputs = [ six ];
  
  checkPhase = ''
    ${python.interpreter} setup.py test
  '';

  # Test is broken
  doCheck = false;
  
  meta = with lib; {
    description = "Helps creating JSON files with Python and JavaScript style inline comments";
    homepage = "https://github.com/vaidik/commentjson";
    license = licenses.mit;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
