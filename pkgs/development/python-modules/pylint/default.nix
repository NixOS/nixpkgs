{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "pylint-1.4.1";
  namePrefix = "";

  src = fetchurl {
    url = "https://pypi.python.org/packages/source/p/pylint/${name}.tar.gz";
    sha256 = "0c7hw1pcp5sqmc0v86zygw21isfgzbsqdmlb1sywncnlxmh30f1y";
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
