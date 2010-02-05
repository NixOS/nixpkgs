args: with args;

stdenv.mkDerivation (rec {
  
  name = "ocaml-cvs-2009-09-24";
  
  src = fetchcvs {
    cvsRoot = ":pserver:anoncvs@camlcvs.inria.fr:/caml";
    module = "ocaml";
    date = "2009-09-24";
    sha256 = "3909bffebc9ce36ca51711d7d95596cba94376ebb1975c6ed46b09c9892c3ef1";
  };

  prefixKey = "-prefix ";
  configureFlags = ["-no-tk"];
  buildFlags = "world" +
    (if (stdenv.system != "armv5tel-linux") then "bootstrap world.opt" else "");
  buildInputs = [ncurses];
  installTargets = "install" + (if (stdenv.system != "armv5tel-linux") then "installopt" else ""); 
  patchPhase = ''
    CAT=$(type -tp cat)
    sed -e "s@/bin/cat@$CAT@" -i config/auto-aux/sharpbang
  '';

  meta = {
    homepage = http://caml.inria.fr/ocaml;
    license = "QPL, LGPL2 (library part)";
    desctiption = "Most popular variant of the Caml language";
  };

})
