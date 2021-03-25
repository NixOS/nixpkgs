{ minor_version, major_version, patch_version
, ...}@args:
let
  versionNoPatch = "${toString major_version}.${toString minor_version}";
  version = "${versionNoPatch}.${toString patch_version}";
  safeX11 = stdenv: !(stdenv.isAarch32 || stdenv.isMips);
in

{ lib, stdenv, fetchurl, ncurses, buildEnv, libunwind
, libX11, xorgproto, useX11 ? safeX11 stdenv && !lib.versionAtLeast version "4.09"
, aflSupport ? false
, flambdaSupport ? false
, spaceTimeSupport ? false
}:

assert useX11 -> !stdenv.isAarch32 && !stdenv.isMips;
assert aflSupport -> lib.versionAtLeast version "4.05";
assert flambdaSupport -> lib.versionAtLeast version "4.03";
assert spaceTimeSupport -> lib.versionAtLeast version "4.04";

let
  src = args.src or (fetchurl {
    url = args.url or "http://caml.inria.fr/pub/distrib/ocaml-${versionNoPatch}/ocaml-${version}.tar.xz";
    inherit (args) sha256;
  });
in

let
   useNativeCompilers = !stdenv.isMips;
   inherit (lib) optional optionals optionalString;
   name = "ocaml${optionalString aflSupport "+afl"}${optionalString spaceTimeSupport "+spacetime"}${optionalString flambdaSupport "+flambda"}-${version}";
in

let
  x11env = buildEnv { name = "x11env"; paths = [libX11 xorgproto]; };
  x11lib = x11env + "/lib";
  x11inc = x11env + "/include";
in

stdenv.mkDerivation (args // {

  inherit name;
  inherit version;

  inherit src;

  prefixKey = "-prefix ";
  configureFlags =
    let flags = new: old:
      if lib.versionAtLeast version "4.08"
      then new else old
    ; in
    optionals useX11 (flags
      [ "--x-libraries=${x11lib}" "--x-includes=${x11inc}"]
      [ "-x11lib" x11lib "-x11include" x11inc ])
  ++ optional aflSupport (flags "--with-afl" "-afl-instrument")
  ++ optional flambdaSupport (flags "--enable-flambda" "-flambda")
  ++ optional spaceTimeSupport (flags "--enable-spacetime" "-spacetime")
  ;

  buildFlags = [ "world" ] ++ optionals useNativeCompilers [ "bootstrap" "world.opt" ];
  buildInputs = optional (!lib.versionAtLeast version "4.07") ncurses
    ++ optionals useX11 [ libX11 xorgproto ];
  propagatedBuildInputs = optional spaceTimeSupport libunwind;
  installTargets = [ "install" ] ++ optional useNativeCompilers "installopt";
  preConfigure = optionalString (!lib.versionAtLeast version "4.04") ''
    CAT=$(type -tp cat)
    sed -e "s@/bin/cat@$CAT@" -i config/auto-aux/sharpbang
  '' + optionalString (stdenv.isDarwin && stdenv.isAarch64) ''
    # Do what upstream does by default now: https://github.com/ocaml/ocaml/pull/10176
    # This is required for aarch64-darwin, everything else works as is.
    AS="${stdenv.cc}/bin/cc -c" ASPP="${stdenv.cc}/bin/cc -c"
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
    broken = stdenv.isAarch64 && !lib.versionAtLeast version "4.06";
  };

})


