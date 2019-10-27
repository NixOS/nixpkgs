{ stdenv
, buildPythonPackage
, fetchPypi
, python
}:
buildPythonPackage rec {
  pname = "plac";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10f0blwxn7k2qvd0vs4300jxb8n9r7jhngf9bx9bfxia8akwy5kw";
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
