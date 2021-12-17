{ lib
, buildPythonPackage
, fetchPypi
, python
}:
buildPythonPackage rec {
  pname = "plac";
  version = "1.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c91a4c9f9cc67c7e7213b6823b0ea15cd0afe5eaf8f8dda1fe5cb10192b137f5";
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
