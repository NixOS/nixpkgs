let
  safeX11 = stdenv: !(stdenv.isArm || stdenv.isMips);
in

{ stdenv, fetchurl, ncurses, buildEnv, libX11, xproto, useX11 ? safeX11 stdenv }:

if useX11 && !(safeX11 stdenv)
  then throw "x11 not available in ocaml with arm or mips arch"
  else # let the indentation flow

let
   useNativeCompilers = !stdenv.isMips;
   inherit (stdenv.lib) optionals optionalString;
in

stdenv.mkDerivation rec {

  x11env = buildEnv { name = "x11env"; paths = [libX11 xproto]; };
  x11lib = x11env + "/lib";
  x11inc = x11env + "/include";

  name = "ocaml-4.01.0";

  src = fetchurl {
    url = "http://caml.inria.fr/pub/distrib/ocaml-4.01/${name}.tar.bz2";
    sha256 = "b1ca708994180236917ae79e17606da5bd334ca6acd6873a550027e1c0ec874a";
  };

  prefixKey = "-prefix ";
  configureFlags = ["-no-tk"] ++ optionals useX11 [ "-x11lib" x11lib
                                                    "-x11include" x11inc ];

  buildFlags = "world" + optionalString useNativeCompilers " bootstrap world.opt";
  buildInputs = [ncurses] ++ optionals useX11 [ libX11 xproto ];
  installTargets = "install" + optionalString useNativeCompilers " installopt";
  preConfigure = ''
    CAT=$(type -tp cat)
    sed -e "s@/bin/cat@$CAT@" -i config/auto-aux/sharpbang
  '';
  postBuild = ''
    mkdir -p $out/include
    ln -sv $out/lib/ocaml/caml $out/include/caml
  '';

  passthru = {
    nativeCompilers = useNativeCompilers;
  };

  meta = {
    homepage = http://caml.inria.fr/ocaml;
    license = [ "QPL" /* compiler */ "LGPLv2" /* library */ ];
    description = "OCaml, the most popular variant of the Caml language";

    longDescription =
      ''
        OCaml is the most popular variant of the Caml language.  From a
        language standpoint, it extends the core Caml language with a
        fully-fledged object-oriented layer, as well as a powerful module
        system, all connected by a sound, polymorphic type system featuring
        type inference.

        The OCaml system is an industrial-strength implementation of this
        language, featuring a high-performance native-code compiler (ocamlopt)
        for 9 processor architectures (IA32, PowerPC, AMD64, Alpha, Sparc,
        Mips, IA64, HPPA, StrongArm), as well as a bytecode compiler (ocamlc)
        and an interactive read-eval-print loop (ocaml) for quick development
        and portability.  The OCaml distribution includes a comprehensive
        standard library, a replay debugger (ocamldebug), lexer (ocamllex) and
        parser (ocamlyacc) generators, a pre-processor pretty-printer (camlp4)
        and a documentation generator (ocamldoc).
      '';

    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };

}
