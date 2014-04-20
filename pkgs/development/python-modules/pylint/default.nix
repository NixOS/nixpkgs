{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "pylint-0.28.0";
  namePrefix = "";

  src = fetchurl {
    url = "http://download.logilab.org/pub/pylint/${name}.tar.gz";
    sha256 = "1077hs8zpl1q5yc6wcg645nfqc4pwbdk8vjcv0qrldbb87f3yv7a";
  };

  propagatedBuildInputs = [ pythonPackages.logilab_astng ];

  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp
    cp "elisp/"*.el $out/share/emacs/site-lisp/
  '';

  meta = {
    homepage = http://www.logilab.org/project/pylint;
    description = "A bug and style checker for Python";
  };
}
