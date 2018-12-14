{ lib
, buildPythonPackage
, fetchPypi
, nose
, pyyaml
}:

buildPythonPackage rec {
  pname = "Markdown";
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0z6v8649sr434d5r5zmrhydka7v7f9yas4bwcgkcs0650jdhybnh";
  };

  checkInputs = [ nose pyyaml ];

  meta = {
    description = "A Python implementation of John Gruber’s Markdown with Extension support";
    homepage = https://github.com/Python-Markdown/markdown;
    license = lib.licenses.bsd3;
  };
}
