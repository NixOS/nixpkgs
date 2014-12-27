{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "pylint-1.4.0";
  namePrefix = "";

  src = fetchurl {
    url = "https://pypi.python.org/packages/source/p/pylint/${name}.tar.gz";
    md5 = "c164738f90213981db5d3297a60b4138";
  };

  propagatedBuildInputs = with pythonPackages; [ astroid ];

  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp
    cp "elisp/"*.el $out/share/emacs/site-lisp/
  '';

  meta = {
    homepage = http://www.logilab.org/project/pylint;
    description = "A bug and style checker for Python";
  };
}
