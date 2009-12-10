args: with args;

stdenv.mkDerivation (rec {
  
  name = "ocaml-3.11.1";
  
  src = fetchurl {
    url = "http://caml.inria.fr/pub/distrib/ocaml-3.11/${name}.tar.bz2";
    sha256 = "8c36a28106d4b683a15c547dfe4cb757a53fa9247579d1cc25bd06a22cc62e50";
  };

  prefixKey = "-prefix ";
  configureFlags = ["-no-tk" "-x11lib" x11];
  buildFlags = "world bootstrap world.opt";
  buildInputs = [x11 ncurses];
  installTargets = "install installopt"; 
  patchPhase = ''
    CAT=$(type -tp cat)
    sed -e "s@/bin/cat@$CAT@" -i config/auto-aux/sharpbang
  '';

  meta = {
    homepage = http://caml.inria.fr/ocaml;
    licenses = [ "QPL" /* compiler */ "LGPLv2" /* library */ ];
    description = "Objective Caml, the most popular variant of the Caml language";

    longDescription =
      '' Objective Caml is the most popular variant of the Caml language.
         From a language standpoint, it extends the core Caml language with a
         fully-fledged object-oriented layer, as well as a powerful module
         system, all connected by a sound, polymorphic type system featuring
         type inference.

         The Objective Caml system is an industrial-strength implementation
         of this language, featuring a high-performance native-code compiler
         (ocamlopt) for 9 processor architectures (IA32, PowerPC, AMD64,
         Alpha, Sparc, Mips, IA64, HPPA, StrongArm), as well as a bytecode
         compiler (ocamlc) and an interactive read-eval-print loop (ocaml)
         for quick development and portability.  The Objective Caml
         distribution includes a comprehensive standard library, a replay
         debugger (ocamldebug), lexer (ocamllex) and parser (ocamlyacc)
         generators, a pre-processor pretty-printer (camlp4) and a
         documentation generator (ocamldoc).
       '';
  };

})
