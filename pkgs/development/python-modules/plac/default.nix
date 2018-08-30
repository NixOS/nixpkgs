{ stdenv
, buildPythonPackage
, fetchPypi
, python
}:
buildPythonPackage rec {
  pname = "plac";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b03f967f535b3bf5a71b191fa5eb09872a5cfb1e3b377efc4138995e10ba36d7";
  };

  checkPhase = ''
      cd doc
      ${python.interpreter} -m unittest discover -p "*test_plac*"
    '';
  
  meta = with stdenv.lib; {
    description = "Parsing the Command Line the Easy Way";
    homepage = https://github.com/micheles/plac;
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ sdll ];
    };
}
