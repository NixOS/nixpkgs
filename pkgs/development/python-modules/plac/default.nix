{ stdenv
, buildPythonPackage
, fetchPypi
, python
}:
buildPythonPackage rec {
  pname = "plac";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ca03587234e5bdd2a3fa96f19a04a01ebb5b0cd66d48ecb5a54d42bc9b287320";
  };

  checkPhase = ''
      cd doc
      ${python.interpreter} -m unittest discover -p "*test_plac*"
    '';

  meta = with stdenv.lib; {
    description = "Parsing the Command Line the Easy Way";
    homepage = "https://github.com/micheles/plac";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ sdll ];
    };
}
