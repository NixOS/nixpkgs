{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "pylint-1.2.1";
  namePrefix = "";

  src = fetchurl {
    url = "https://pypi.python.org/packages/source/p/pylint/${name}.tar.gz";
    sha256 = "0q7zj5hgmz27wifhcqyaddc9yc5b2q6p16788zzm3da6qshv7xk3";
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
