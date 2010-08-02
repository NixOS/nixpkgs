{ stdenv, fetchurl, x11 }:

stdenv.mkDerivation {
  name = "ocaml-3.08.0";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nixos.org/tarballs/ocaml-3.08.0.tar.gz;
    md5 = "c6ef478362295c150101cdd2efcd38e0";
  };
  configureScript = ./configure-3.08.0;
  dontAddPrefix = "True";
  configureFlags = ["-no-tk" "-x11lib" x11];
  buildFlags = ["world" "bootstrap" "opt"];
  checkTarget = ["opt.opt"];
}
