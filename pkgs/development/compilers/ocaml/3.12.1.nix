{ stdenv, fetchurl, ncurses, xlibsWrapper }:

let
   useX11 = !stdenv.isArm && !stdenv.isMips;
   useNativeCompilers = !stdenv.isMips;
   inherit (stdenv.lib) optionals optionalString;
in

stdenv.mkDerivation rec {
  
  name = "ocaml-3.12.1";
  
  src = fetchurl {
    url = "http://caml.inria.fr/pub/distrib/ocaml-3.12/${name}.tar.bz2";
    sha256 = "13cmhkh7s6srnlvhg3s9qzh3a5dbk2m9qr35jzq922sylwymdkzd";
  };

  prefixKey = "-prefix ";
  configureFlags = ["-no-tk"] ++ optionals useX11 [ "-x11lib" xlibsWrapper ];
  buildFlags = "world" + optionalString useNativeCompilers " bootstrap world.opt";
  buildInputs = [ncurses] ++ optionals useX11 [ xlibsWrapper ];
  installTargets = "install" + optionalString useNativeCompilers " installopt";
  patches = optionals stdenv.isDarwin [ ./3.12.1-darwin-fix-configure.patch ];
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
    branch = "3.12";
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
  };

}
