{ lib
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  version = "0.1.4";
  pname = "forbiddenfruit";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e3f7e66561a29ae129aac139a85d610dbf3dd896128187ed5454b6421f624253";
  };

  checkInputs = [ nose ];

  checkPhase = ''
    find ./build -name '*.so' -exec mv {} tests/unit \;
    nosetests
  '';

  meta = with lib; {
    description = "Patch python built-in objects";
    homepage = "https://pypi.python.org/pypi/forbiddenfruit";
    license = licenses.mit;
  };

}
