{ lib
, buildPythonPackage
, fetchPypi
, python
}:
buildPythonPackage rec {
  pname = "plac";
  version = "1.3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-OL3YZNBFD7dIGTqoF7nEWKj1MZ+/l7ImEVHPwKWBIJA=";
  };

  checkPhase = ''
    cd doc
    ${python.interpreter} -m unittest discover -p "*test_plac*"
  '';

  meta = with lib; {
    description = "Parsing the Command Line the Easy Way";
    homepage = "https://github.com/micheles/plac";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ ];
  };
}
