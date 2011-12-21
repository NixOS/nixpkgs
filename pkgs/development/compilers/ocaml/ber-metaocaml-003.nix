{ stdenv, fetchurl, ncurses, x11 }:

let
   useX11 = stdenv.isi686 || stdenv.isx86_64;
   useNativeCompilers = stdenv.isi686 || stdenv.isx86_64 || stdenv.isMips;
   inherit (stdenv.lib) optionals optionalString;
in

stdenv.mkDerivation rec {
  
  name = "ber-metaocaml-003";
  
  src = fetchurl {
    url = "http://caml.inria.fr/pub/distrib/ocaml-3.11/ocaml-3.11.2.tar.bz2";
    sha256 = "0hw1yp1mmfyn1pmda232d0ry69m7ln1z0fn5lgi8nz3y1mx3iww6";
  };

  metaocaml = fetchurl {
    url = "http://okmij.org/ftp/ML/ber-metaocaml.tar.gz";
    sha256 = "1kq1if25c1wvcdiy4g46xk05dkc1am2gc4qvmg4x19wvvaz09gzf";
  };

  # Needed to avoid a SIGBUS on the final executable on mips
  NIX_CFLAGS_COMPILE = if stdenv.isMips then "-fPIC" else "";

  patches = optionals stdenv.isDarwin [ ./gnused-on-osx-fix.patch ];

  prefixKey = "-prefix ";
  configureFlags = ["-no-tk"] ++ optionals useX11 [ "-x11lib" x11 ];
  buildFlags = "core coreboot all"; # "world" + optionalString useNativeCompilers " bootstrap world.opt";
  buildInputs = [ncurses] ++ optionals useX11 [ x11 ];
  installFlags = "-i";
  installTargets = "install"; # + optionalString useNativeCompilers " installopt";
  prePatch = ''
    CAT=$(type -tp cat)
    sed -e "s@/bin/cat@$CAT@" -i config/auto-aux/sharpbang
    patch -p0 < ${./mips64.patch}
  '';
  postConfigure = ''
    tar -xvzf $metaocaml
    cd ${name}
    make patch
    cd ..
  '';
  postBuild = ''
    ensureDir $out/include
    ln -sv $out/lib/ocaml/caml $out/include/caml
  '';
  postInstall = ''
    cd ${name}
    make all
    make install
    make test
    make test-compile
    cd ..
  '';

  meta = {
    homepage = "http://okmij.org/ftp/ML/index.html#ber-metaocaml";
    licenses = [ "QPL" /* compiler */ "LGPLv2" /* library */ ];
    description = "a conservative extension of OCaml with the primitive type of code values, and three basic multi-stage expression forms: Brackets, Escape, and Run";
  };
}
