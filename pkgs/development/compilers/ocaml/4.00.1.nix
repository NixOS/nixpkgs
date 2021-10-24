{ lib, stdenv, fetchurl, ncurses, xlibsWrapper }:

let
   useX11 = !stdenv.isAarch32 && !stdenv.isMips;
   useNativeCompilers = !stdenv.isMips;
   inherit (lib) optional optionals optionalString;
in

stdenv.mkDerivation rec {
  pname = "ocaml";
  version = "4.00.1";

  src = fetchurl {
    url = "https://caml.inria.fr/pub/distrib/ocaml-4.00/${pname}-${version}.tar.bz2";
    sha256 = "33c3f4acff51685f5bfd7c260f066645e767d4e865877bf1613c176a77799951";
  };

  prefixKey = "-prefix ";
  configureFlags = [ "-no-tk" ] ++ optionals useX11 [ "-x11lib" xlibsWrapper ];

  # Older versions have some race:
  #  cp: cannot stat 'boot/ocamlrun': No such file or directory
  #  make[2]: *** [Makefile:199: backup] Error 1
  enableParallelBuilding = lib.versionAtLeast version "4.06";

  # Workaround lack of parallelism support among top-level targets:
  # we place nixpkgs-specific targets to a separate file and set
  # sequential order among them as a single rule.
  makefile = ./Makefile.nixpkgs;
  buildFlags = if useNativeCompilers
    then ["nixpkgs_world_bootstrap_world_opt"]
    else ["nixpkgs_world"];

  buildInputs = [ ncurses ] ++ optional useX11 xlibsWrapper;
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

  meta = with lib; {
    homepage = "http://caml.inria.fr/ocaml";
    branch = "4.00";
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

    platforms = with platforms; linux;
  };

}
