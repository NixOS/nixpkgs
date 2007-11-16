args: with args;

stdenv.mkDerivation {
  name = "ocaml-3.09.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://caml.inria.fr/pub/distrib/ocaml-3.09/ocaml-3.09.1.tar.gz;
    md5 = "c73f4b093e27ba5bf13d62923f89befc";
  };
  configureScript = ./configure-3.09.1;
  dontAddPrefix = "True";
  configureFlags = ["-no-tk" "-x11lib" x11];
  buildFlags = ["world" "bootstrap" "opt"];
  checkTarget = ["opt.opt"];
  buildInputs = [x11  ncurses];
}
