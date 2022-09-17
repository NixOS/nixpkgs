{ lib, buildPythonPackage, fetchPypi
}:
buildPythonPackage rec {
  pname = "constantly";
  version = "15.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dgwdla5kfpqz83hfril716inm41hgn9skxskvi77605jbmp4qsq";
  };

  pythonImportsCheck = [ "constantly" ];

  meta = with lib; {
    homepage = "https://github.com/twisted/constantly";
    description = "symbolic constant support";
    license = licenses.mit;
    maintainers = [ ];
  };
}
