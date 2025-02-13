{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  ncurses,
  libX11,
}:

let
  useX11 = !stdenv.hostPlatform.isAarch32 && !stdenv.hostPlatform.isMips;
  useNativeCompilers = !stdenv.hostPlatform.isMips;
  inherit (lib) optional optionals optionalString;
in

stdenv.mkDerivation rec {
  pname = "ocaml";
  version = "4.00.1";

  src = fetchurl {
    url = "https://caml.inria.fr/pub/distrib/ocaml-4.00/${pname}-${version}.tar.bz2";
    sha256 = "33c3f4acff51685f5bfd7c260f066645e767d4e865877bf1613c176a77799951";
  };

  # Compatibility with Glibc 2.34
  patches = [
    (fetchpatch {
      url = "https://github.com/ocaml/ocaml/commit/60b0cdaf2519d881947af4175ac4c6ff68901be3.patch";
      sha256 = "sha256:07g9q9sjk4xsbqix7jxggfp36v15pmqw4bms80g5car0hfbszirn";
    })
  ];

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: libcamlrun.a(startup.o):(.bss+0x800): multiple definition of
  #     `caml_code_fragments_table'; libcamlrun.a(backtrace.o):(.bss+0x20): first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  prefixKey = "-prefix ";
  configureFlags =
    [ "-no-tk" ]
    ++ optionals useX11 [
      "-x11lib"
      libX11
    ];
  buildFlags =
    [ "world" ]
    ++ optionals useNativeCompilers [
      "bootstrap"
      "world.opt"
    ];
  buildInputs = [ ncurses ] ++ optionals useX11 [ libX11 ];
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
      qpl # compiler
      lgpl2 # library
    ];
    description = "Most popular variant of the Caml language";

    longDescription = ''
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
