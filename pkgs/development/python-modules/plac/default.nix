{ stdenv
, buildPythonPackage
, fetchPypi
, python
}:
buildPythonPackage rec {
  pname = "plac";
  version = "1.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "398cb947c60c4c25e275e1f1dadf027e7096858fb260b8ece3b33bcff90d985f";
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
