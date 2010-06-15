args: with args;

stdenv.mkDerivation {
  name = "ocaml-3.08.0";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nixos.org/tarballs/ocaml-3.08.0.tar.gz;
    md5 = "c6ef478362295c150101cdd2efcd38e0";
  };
  NUM_CORES = 1; # both fail: build and install
  configureScript = ./configure-3.08.0;
  dontAddPrefix = "True";
  configureFlags = ["-no-tk" "-x11lib" x11];
  buildFlags = ["world" "bootstrap" "opt"];
  checkTarget = ["opt.opt"];
}
