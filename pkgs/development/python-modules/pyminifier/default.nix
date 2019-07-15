{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "pyminifier";
  version = "2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xv7ahlb6bdbpwvsy1cyckl5lmf9if134nw2k290x0q1x67n34p1";
  };

  buildInputs = [ ];

  doCheck = false;

  meta = {
    homepage = https://github.com/liftoff/pyminifier; 
    description = "python code minifier";
    maintainers = with lib.maintainers; [ mog ];
    license = lib.licenses.mit;
  };
}
