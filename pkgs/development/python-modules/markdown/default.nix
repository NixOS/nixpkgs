{ lib
, buildPythonPackage
, fetchPypi
, nose
, pyyaml
}:

buildPythonPackage rec {
  pname = "Markdown";
  version = "2.6.10";

  src = fetchPypi {
    extension = "zip";
    inherit pname version;
    sha256 = "cfa536d1ee8984007fcecc5a38a493ff05c174cb74cb2341dafd175e6bc30851";
  };

  # error: invalid command 'test'
#   doCheck = false;

  checkInputs = [ nose pyyaml ];

  meta = {
    description = "A Python implementation of John Gruber’s Markdown with Extension support";
    homepage = https://github.com/Python-Markdown/markdown;
    license = lib.licenses.bsd3;
  };
}
