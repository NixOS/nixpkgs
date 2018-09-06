{ stdenv, fetchurl, ncurses, libX11, xproto, buildEnv }:

let
   useX11 = stdenv.isi686 || stdenv.isx86_64;
   inherit (stdenv.lib) optionals;
in

stdenv.mkDerivation rec {

  name = "ber-metaocaml-${version}";
  version = "104";

  src = fetchurl {
    url = "https://caml.inria.fr/pub/distrib/ocaml-4.04/ocaml-4.04.0.tar.gz";
    sha256 = "1pi2hdm9lxhn45qvfqfss1hpa4jijm14qgmrgajsadxqdiplhqyb";
  };

  metaocaml = fetchurl {
    url = "http://okmij.org/ftp/ML/ber-metaocaml-104.tar.gz";
    sha256 = "1gmwlxairxqcmqa2r6kbf8b4dxc7pfhfbh48g1s14d3z20rj8nib";
  };

  # Needed to avoid a SIGBUS on the final executable on mips
  NIX_CFLAGS_COMPILE = if stdenv.isMips then "-fPIC" else "";

  x11env = buildEnv { name = "x11env"; paths = [libX11 xproto];};
  x11lib = x11env + "/lib";
  x11inc = x11env + "/include";

  prefixKey = "-prefix ";
  configureFlags = optionals useX11 [ "-x11lib" x11lib
                                      "-x11include" x11inc ];

  dontStrip = true;
  buildInputs = [ncurses] ++ optionals useX11 [ libX11 xproto ];
  installFlags = "-i";
  installTargets = "install"; # + optionalString useNativeCompilers " installopt";

  postConfigure = ''
    tar -xvzf $metaocaml
    cd ${name}
    make patch
    cd ..
  '';
  buildPhase = ''
    make world
    make -i install

    make bootstrap
    make opt.opt
    make installopt
    mkdir -p $out/include
    ln -sv $out/lib/ocaml/caml $out/include/caml
    cd ${name}
    make all
    make install
    make install.opt
    cd ..
 '';
  installPhase = "";
  postBuild = ''
  '';
  checkPhase = ''
    cd ${name}
    make test
    make test-compile
    make test-native
    cd ..
  '';

  meta = with stdenv.lib; {
    homepage = "http://okmij.org/ftp/ML/index.html#ber-metaocaml";
    license = with licenses; [
      qpl /* compiler */
      lgpl2 /* library */
    ];
    description = "Conservative extension of OCaml";
    longDescription = ''
      A conservative extension of OCaml with the primitive type of code values,
      and three basic multi-stage expression forms: Brackets, Escape, and Run
    '';
  };
}
