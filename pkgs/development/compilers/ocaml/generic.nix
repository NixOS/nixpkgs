{ minor_version, major_version, patch_version, patches ? []
, ...}@args:
let
  versionNoPatch = "${toString major_version}.${toString minor_version}";
  version = "${versionNoPatch}.${toString patch_version}";
  safeX11 = stdenv: !(stdenv.isAarch32 || stdenv.isMips || stdenv.hostPlatform.isStatic);
in

{ lib, stdenv, fetchurl, ncurses, buildEnv, libunwind, fetchpatch
, libX11, xorgproto, useX11 ? safeX11 stdenv && lib.versionOlder version "4.09"
, aflSupport ? false
, flambdaSupport ? false
, spaceTimeSupport ? false
, unsafeStringSupport ? false
}:

assert useX11 -> safeX11 stdenv;
assert aflSupport -> lib.versionAtLeast version "4.05";
assert flambdaSupport -> lib.versionAtLeast version "4.03";
assert spaceTimeSupport -> lib.versionAtLeast version "4.04";
assert unsafeStringSupport -> lib.versionAtLeast version "4.06" && lib.versionOlder version "5.0";

let
  src = args.src or (fetchurl {
    url = args.url or "http://caml.inria.fr/pub/distrib/ocaml-${versionNoPatch}/ocaml-${version}.tar.xz";
    inherit (args) sha256;
  });
in

let
   useNativeCompilers = !stdenv.isMips;
   inherit (lib) optional optionals optionalString;
   pname = "ocaml${optionalString aflSupport "+afl"}${optionalString spaceTimeSupport "+spacetime"}${optionalString flambdaSupport "+flambda"}";
in

let
  x11env = buildEnv { name = "x11env"; paths = [libX11 xorgproto]; };
  x11lib = x11env + "/lib";
  x11inc = x11env + "/include";

  fetchpatch' = x: if builtins.isAttrs x then fetchpatch x else x;
in

stdenv.mkDerivation (args // {

  inherit pname version src;

  patches = map fetchpatch' patches;

  strictDeps = true;

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
  ++ optionals unsafeStringSupport [
    "--disable-force-safe-string"
    "DEFAULT_STRING=unsafe"
  ]
  ++ optional (stdenv.hostPlatform.isStatic && (lib.versionOlder version "4.08")) "-no-shared-libs"
  ++ optionals (stdenv.hostPlatform != stdenv.buildPlatform && lib.versionOlder version "4.08") [
    "-host ${stdenv.hostPlatform.config}"
    "-target ${stdenv.targetPlatform.config}"
  ];
  dontAddStaticConfigureFlags = lib.versionOlder version "4.08";

  # on aarch64-darwin using --host and --target causes the build to invoke
  # `aarch64-apple-darwin-clang` while using assembler. However, such binary
  # does not exist. So, disable these configure flags on `aarch64-darwin`.
  # See #144785 for details.
  configurePlatforms = lib.optionals (lib.versionAtLeast version "4.08" && !(stdenv.isDarwin && stdenv.isAarch64)) [ "host" "target" ];
  # x86_64-unknown-linux-musl-ld: -r and -pie may not be used together
  hardeningDisable = lib.optional (lib.versionAtLeast version "4.09" && stdenv.hostPlatform.isMusl) "pie"
    ++ lib.optional (lib.versionAtLeast version "5.0" && stdenv.cc.isClang) "strictoverflow"
    ++ lib.optionals (args ? hardeningDisable) args.hardeningDisable;

  # Older versions have some race:
  #  cp: cannot stat 'boot/ocamlrun': No such file or directory
  #  make[2]: *** [Makefile:199: backup] Error 1
  enableParallelBuilding = lib.versionAtLeast version "4.08";

  # Workaround lack of parallelism support among top-level targets:
  # we place nixpkgs-specific targets to a separate file and set
  # sequential order among them as a single rule.
  makefile = ./Makefile.nixpkgs;
  buildFlags = if useNativeCompilers
    then ["nixpkgs_world_bootstrap_world_opt"]
    else ["nixpkgs_world"];
  buildInputs = optional (lib.versionOlder version "4.07") ncurses
    ++ optionals useX11 [ libX11 xorgproto ];
  propagatedBuildInputs = optional spaceTimeSupport libunwind;
  installTargets = [ "install" ] ++ optional useNativeCompilers "installopt";
  preConfigure = optionalString (lib.versionOlder version "4.04") ''
    CAT=$(type -tp cat)
    sed -e "s@/bin/cat@$CAT@" -i config/auto-aux/sharpbang
  '' + optionalString (stdenv.isDarwin) ''
    # Do what upstream does by default now: https://github.com/ocaml/ocaml/pull/10176
    # This is required for aarch64-darwin, everything else works as is.
    AS="${stdenv.cc}/bin/cc -c" ASPP="${stdenv.cc}/bin/cc -c"
  '' + optionalString (lib.versionOlder version "4.08" && stdenv.hostPlatform.isStatic) ''
    configureFlagsArray+=("-cc" "$CC" "-as" "$AS" "-partialld" "$LD -r")
  '';
  postBuild = ''
    mkdir -p $out/include
    ln -sv $out/lib/ocaml/caml $out/include/caml
  '';

  passthru = {
    nativeCompilers = useNativeCompilers;
  };

  meta = with lib; {
    homepage = "https://ocaml.org/";
    branch = versionNoPatch;
    license = with licenses; [
      qpl /* compiler */
      lgpl2 /* library */
    ];
    description = "OCaml is an industrial-strength programming language supporting functional, imperative and object-oriented styles";

    longDescription = ''
      OCaml is a general purpose programming language with an emphasis on expressiveness and safety. Developed for more than 20 years at Inria by a group of leading researchers, it has an advanced type system that helps catch your mistakes without getting in your way. It's used in environments where a single mistake can cost millions and speed matters, is supported by an active community, and has a rich set of libraries and development tools. It's widely used in teaching for its power and simplicity.

      Strengths:
      * A powerful type system, equipped with parametric polymorphism and type inference. For instance, the type of a collection can be parameterized by the type of its elements. This allows defining some operations over a collection independently of the type of its elements: sorting an array is one example. Furthermore, type inference allows defining such operations without having to explicitly provide the type of their parameters and result.
      * User-definable algebraic data types and pattern-matching. New algebraic data types can be defined as combinations of records and sums. Functions that operate over such data structures can then be defined by pattern matching, a generalized form of the well-known switch statement, which offers a clean and elegant way of simultaneously examining and naming data.
      * Automatic memory management, thanks to a fast, unobtrusive, incremental garbage collector.
      * Separate compilation of standalone applications. Portable bytecode compilers allow creating stand-alone applications out of Caml Light or OCaml programs. A foreign function interface allows OCaml code to interoperate with C code when necessary. Interactive use of OCaml is also supported via a “read-evaluate-print” loop.

      In addition, OCaml features:
      * A sophisticated module system, which allows organizing modules hierarchically and parameterizing a module over a number of other modules.
      * An expressive object-oriented layer, featuring multiple inheritance, parametric and virtual classes.
      * Efficient native code compilers. In addition to its bytecode compiler, OCaml offers a compiler that produces efficient machine code for many architectures.

      Learn more at: https://ocaml.org/learn/description.html
    '';

    platforms = with platforms; linux ++ darwin;
    broken = stdenv.isAarch64 && lib.versionOlder version (if stdenv.isDarwin then "4.10" else "4.02");
  };

})
