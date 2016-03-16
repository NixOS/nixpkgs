{ stdenv, fetchurl, ncurses, xlibsWrapper }:

let
   useX11 = stdenv.isi686 || stdenv.isx86_64;
   useNativeCompilers = stdenv.isi686 || stdenv.isx86_64 || stdenv.isMips;
   inherit (stdenv.lib) optionals optionalString;
in

stdenv.mkDerivation rec {
  
  name = "ocaml-3.11.2";
  
  src = fetchurl {
    url = "http://caml.inria.fr/pub/distrib/ocaml-3.11/${name}.tar.bz2";
    sha256 = "86f3387a0d7e7c8be2a3c53af083a5a726e333686208d5ea0dd6bb5ac3f58143";
  };

  # Needed to avoid a SIGBUS on the final executable on mips
  NIX_CFLAGS_COMPILE = if stdenv.isMips then "-fPIC" else "";

  patches = optionals stdenv.isDarwin [ ./gnused-on-osx-fix.patch ] ++
    [ (fetchurl {
        name = "0007-Fix-ocamlopt-w.r.t.-binutils-2.21.patch";
        url = "http://caml.inria.fr/mantis/file_download.php?file_id=418&type=bug";
	sha256 = "612a9ac108bbfce2238aa5634123da162f0315dedb219958be705e0d92dcdd8e";
      })
    ];

  prefixKey = "-prefix ";
  configureFlags = ["-no-tk"] ++ optionals useX11 [ "-x11lib" xlibsWrapper ];
  buildFlags = "world" + optionalString useNativeCompilers " bootstrap world.opt";
  buildInputs = [ncurses] ++ optionals useX11 [ xlibsWrapper ];
  installTargets = "install" + optionalString useNativeCompilers " installopt";
  prePatch = ''
    CAT=$(type -tp cat)
    sed -e "s@/bin/cat@$CAT@" -i config/auto-aux/sharpbang
    patch -p0 < ${./mips64.patch}
  '';
  postBuild = ''
    mkdir -p $out/include
    ln -sv $out/lib/ocaml/caml $out/include/caml
  '';

  meta = with stdenv.lib; {
    homepage = http://caml.inria.fr/ocaml;
    license = with licenses; [
      qpl /* compiler */
      lgpl2 /* library */
    ];
    description = "Most popular variant of the Caml language";

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

    platforms = with platforms; linux ++ darwin;
    hydraPlatforms = with platforms; linux ++ darwin;
  };

}
