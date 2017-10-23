{ minor_version, major_version, patch_version
, url ? null
, sha256, ...}@args:
let
  versionNoPatch = "${toString major_version}.${toString minor_version}";
  version = "${versionNoPatch}.${toString patch_version}";
  real_url = if url == null then
    "http://caml.inria.fr/pub/distrib/ocaml-${versionNoPatch}/ocaml-${version}.tar.xz"
  else url;
  safeX11 = stdenv: !(stdenv.isArm || stdenv.isMips);
in

{ stdenv, fetchurl, ncurses, buildEnv, libX11, xproto, useX11 ? safeX11 stdenv }:

assert useX11 -> !stdenv.isArm && !stdenv.isMips;

let
   useNativeCompilers = !stdenv.isMips;
   inherit (stdenv.lib) optionals optionalString;
   name = "ocaml-${version}";
in

stdenv.mkDerivation (args // rec {

  x11env = buildEnv { name = "x11env"; paths = [libX11 xproto]; };
  x11lib = x11env + "/lib";
  x11inc = x11env + "/include";

  inherit name;
  inherit version;

  src = fetchurl {
    url = real_url;
    inherit sha256;
  };

  prefixKey = "-prefix ";
  configureFlags = optionals useX11 [ "-x11lib" x11lib
                                      "-x11include" x11inc ];

  buildFlags = "world" + optionalString useNativeCompilers " bootstrap world.opt";
  buildInputs = [ncurses] ++ optionals useX11 [ libX11 xproto ];
  installTargets = "install" + optionalString useNativeCompilers " installopt";
  preConfigure = optionalString (!stdenv.lib.versionAtLeast version "4.04") ''
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
    branch = versionNoPatch;
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

})


