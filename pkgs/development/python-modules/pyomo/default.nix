{ lib
, buildPythonPackage
, fetchPypi
, pyutilib
, ply
, appdirs
}:

buildPythonPackage rec {
  pname = "Pyomo";
  version = "5.4.3";

  propagatedBuildInputs = [ pyutilib ply appdirs ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "08hgpf8fs8n8zlpmv3zlcgdw6306ymq1m9ma92v3x5nqnkhqfa3j";
  };

  # Tests try to install packages
  doCheck = false;

  meta = with lib; {
    homepage    = http://www.pyomo.org/;
    description = "Collection of software packages for formulating optimization models";
    longDescription = ''
      Pyomo is a Python-based, open-source optimization modeling language
      with a diverse set of optimization capabilities.
    '';
    license     = lib.licenses.bsd3;
    maintainers = with maintainers; [ ericsagnes ];
  };
}
