{ lib
, buildPythonPackage
, fetchPypi
, nose
, pyyaml
}:

buildPythonPackage rec {
  pname = "Markdown";
  version = "3.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2e50876bcdd74517e7b71f3e7a76102050edec255b3983403f1a63e7c8a41e7a";
  };

  checkInputs = [ nose pyyaml ];

  meta = {
    description = "A Python implementation of John Gruber's Markdown with Extension support";
    homepage = "https://github.com/Python-Markdown/markdown";
    license = lib.licenses.bsd3;
  };
}
