let
  safeX11 = stdenv: !(stdenv.isArm || stdenv.isMips);
in

{ stdenv, fetchurl, ncurses, buildEnv, libX11, xproto, useX11 ? safeX11 stdenv }:

assert useX11 -> !stdenv.isArm && !stdenv.isMips;

let
   useNativeCompilers = !stdenv.isMips;
   inherit (stdenv.lib) optionals optionalString;
in

stdenv.mkDerivation rec {

  x11env = buildEnv { name = "x11env"; paths = [libX11 xproto]; };
  x11lib = x11env + "/lib";
  x11inc = x11env + "/include";

  name = "ocaml-4.02.3";

  src = fetchurl {
    url = "http://caml.inria.fr/pub/distrib/ocaml-4.02/${name}.tar.xz";
    sha256 = "1qwwvy8nzd87hk8rd9sm667nppakiapnx4ypdwcrlnav2dz6kil3";
  };

  patches = [ ./ocamlbuild.patch ];

  prefixKey = "-prefix ";
  configureFlags = optionals useX11 [ "-x11lib" x11lib
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

  meta = with stdenv.lib; {
    homepage = http://caml.inria.fr/ocaml;
    branch = "4.02";
    license = with licenses; [
      qpl /* compiler */
      lgpl2 /* library */
    ];
    description = "Most popular variant of the Caml language";

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

    platforms = with platforms; linux ++ darwin;
    hydraPlatforms = with platforms; linux ++ darwin;
  };

}
