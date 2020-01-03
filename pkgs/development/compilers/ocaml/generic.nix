{ minor_version, major_version, patch_version
, url ? null
, sha256, ...}@args:
let
  versionNoPatch = "${toString major_version}.${toString minor_version}";
  version = "${versionNoPatch}.${toString patch_version}";
  real_url = if url == null then
    "http://caml.inria.fr/pub/distrib/ocaml-${versionNoPatch}/ocaml-${version}.tar.xz"
  else url;
  safeX11 = stdenv: !(stdenv.isAarch32 || stdenv.isMips);
in

{ stdenv, fetchurl, ncurses, buildEnv
, libX11, xorgproto, useX11 ? safeX11 stdenv
, aflSupport ? false
, flambdaSupport ? false
}:

assert useX11 -> !stdenv.isAarch32 && !stdenv.isMips;
assert aflSupport -> stdenv.lib.versionAtLeast version "4.05";
assert flambdaSupport -> stdenv.lib.versionAtLeast version "4.03";

let
   useNativeCompilers = !stdenv.isMips;
   inherit (stdenv.lib) optional optionals optionalString;
   name = "ocaml${optionalString aflSupport "+afl"}${optionalString flambdaSupport "+flambda"}-${version}";
in

let
  x11env = buildEnv { name = "x11env"; paths = [libX11 xorgproto]; };
  x11lib = x11env + "/lib";
  x11inc = x11env + "/include";
in

stdenv.mkDerivation (args // {

  inherit name;
  inherit version;

  src = fetchurl {
    url = real_url;
    inherit sha256;
  };

  prefixKey = "-prefix ";
  configureFlags =
    let flags = new: old:
      if stdenv.lib.versionAtLeast version "4.08"
      then new else old
    ; in
    optionals useX11 (flags
      [ "--x-libraries=${x11lib}" "--x-includes=${x11inc}"]
      [ "-x11lib" x11lib "-x11include" x11inc ])
  ++ optional aflSupport (flags "--with-afl" "-afl-instrument")
  ++ optional flambdaSupport (flags "--enable-flambda" "-flambda")
  ;

  buildFlags = [ "world" ] ++ optionals useNativeCompilers [ "bootstrap" "world.opt" ];
  buildInputs = optional (!stdenv.lib.versionAtLeast version "4.07") ncurses
    ++ optionals useX11 [ libX11 xorgproto ];
  installTargets = [ "install" ] ++ optional useNativeCompilers "installopt";
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
    broken = stdenv.isAarch64 && !stdenv.lib.versionAtLeast version "4.06";
  };

})


