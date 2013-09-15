{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "pylint-0.26.0";
  namePrefix = "";

  src = fetchurl {
    url = "http://download.logilab.org/pub/pylint/${name}.tar.gz";
    sha256 = "1mg1ywpj0klklv63s2hwn5xwxi3wfwgnyz9d4pz32hzb53azq835";
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
