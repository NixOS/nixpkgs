{ stdenv, fetchurl, xlibsWrapper }:

stdenv.mkDerivation rec {
  name = "ocaml-${version}";
  version = "3.08.0";

  builder = ./builder.sh;
  src = fetchurl {
    url = "http://tarballs.nixos.org/${name}.tar.gz";
    sha256 = "135g5waj7djzrj0dbc8z1llasfs2iv5asq41jifhldxb4l2b97mx";
  };
  configureScript = ./configure-3.08.0;
  dontAddPrefix = "True";
  configureFlags = ["-no-tk" "-x11lib" xlibsWrapper];
  buildFlags = ["world" "bootstrap" "opt"];
  checkTarget = ["opt.opt"];

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
