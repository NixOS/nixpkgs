{ stdenv
, buildPythonPackage
, fetchPypi
, python
}:
buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "plac";
  version = "0.9.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16zqpalx4i1n1hrcvaj8sdixapy2g76fc13bbahz0xc106d72gxs";
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
