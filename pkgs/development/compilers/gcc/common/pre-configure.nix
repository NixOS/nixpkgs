{ lib
, stdenv
, version, buildPlatform, hostPlatform, targetPlatform
, gnat-bootstrap ? null
, langAda ? false
, langFortran
, langJava ? false
, langJit ? false
, langGo
, withoutTargetLibc
, enableShared
, enableMultilib
, pkgsBuildTarget
}:

assert langJava -> lib.versionOlder version "7";
assert langAda -> gnat-bootstrap != null; let
  needsLib
    =  (lib.versionOlder version "7" && (langJava || langGo))
    || (lib.versions.major version == "4" && lib.versions.minor version == "9" && targetPlatform.isDarwin);
in lib.optionalString (hostPlatform.isSunOS && hostPlatform.is64bit) ''
  export NIX_LDFLAGS=`echo $NIX_LDFLAGS | sed -e s~$prefix/lib~$prefix/lib/amd64~g`
  export LDFLAGS_FOR_TARGET="-Wl,-rpath,$prefix/lib/amd64 $LDFLAGS_FOR_TARGET"
  export CXXFLAGS_FOR_TARGET="-Wl,-rpath,$prefix/lib/amd64 $CXXFLAGS_FOR_TARGET"
  export CFLAGS_FOR_TARGET="-Wl,-rpath,$prefix/lib/amd64 $CFLAGS_FOR_TARGET"
'' + lib.optionalString needsLib ''
  export lib=$out;
'' + lib.optionalString langAda ''
  export PATH=${gnat-bootstrap}/bin:$PATH
''

# For a cross-built native compiler, i.e. build!=(host==target), the
# bundled libgfortran needs a gfortran which can run on the
# buildPlatform and emit code for the targetPlatform.  The compiler
# which is built alongside gfortran in this configuration doesn't
# meet that need: it runs on the hostPlatform.
+ lib.optionalString (langFortran && (with stdenv; buildPlatform != hostPlatform && hostPlatform == targetPlatform)) ''
  export GFORTRAN_FOR_TARGET=${pkgsBuildTarget.gfortran}/bin/${stdenv.targetPlatform.config}-gfortran
''

# On x86_64-darwin, the gnat-bootstrap bootstrap compiler that we need to build a
# native GCC with Ada support emits assembly that is accepted by the Clang
# integrated assembler, but not by the GNU assembler in cctools-port that Nix
# usually in the x86_64-darwin stdenv.  In particular, x86_64-darwin gnat-bootstrap
# emits MOVQ as the mnemonic for quadword interunit moves, such as between XMM
# and general registers (e.g "movq %xmm0, %rbp"); the cctools-port assembler,
# however, only recognises MOVD for such moves.
#
# Therefore, for native x86_64-darwin builds that support Ada, we have to use
# the Clang integrated assembler to build (at least stage 1 of) GCC, but have to
# target GCC at the cctools-port GNU assembler.  In the wrapped x86_64-darwin
# gnat-bootstrap, the former is provided as `as`, while the latter is provided as
# `gas`.
#
+ lib.optionalString (
    langAda
    && buildPlatform == hostPlatform
    && hostPlatform == targetPlatform
    && targetPlatform.isx86_64
    && targetPlatform.isDarwin
  ) ''
  export AS_FOR_BUILD=${gnat-bootstrap}/bin/as
  export AS_FOR_TARGET=${gnat-bootstrap}/bin/gas
''

# NOTE 2020/3/18: This environment variable prevents configure scripts from
# detecting the presence of aligned_alloc on Darwin.  There are many facts that
# collectively make this fix necessary:
#  - Nix uses a fixed set of standard library headers on all MacOS systems,
#    regardless of their actual version.  (Nix uses version 10.12 headers.)
#  - Nix uses the native standard library binaries for the build system.  That
#    means the standard library binaries may not exactly match the standard
#    library headers.
#  - The aligned_alloc procedure is present in MacOS 10.15 (Catalina), but not
#    in earlier versions.  Therefore on Catalina systems, aligned_alloc is
#    linkable (i.e. present in the binary libraries) but not present in the
#    headers.
#  - Configure scripts detect a procedure's existence by checking whether it is
#    linkable.  They do not check whether it is present in the headers.
#  - GCC throws an error during compilation because aligned_alloc is not
#    defined in the headers---even though the linker can see it.
#
# This fix would not be necessary if ANY of the above were false:
#  - If Nix used native headers for each different MacOS version, aligned_alloc
#    would be in the headers on Catalina.
#  - If Nix used the same library binaries for each MacOS version, aligned_alloc
#    would not be in the library binaries.
#  - If Catalina did not include aligned_alloc, this wouldn't be a problem.
#  - If the configure scripts looked for header presence as well as
#    linkability, they would see that aligned_alloc is missing.
#  - If GCC allowed implicit declaration of symbols, it would not fail during
#    compilation even if the configure scripts did not check header presence.
#
+ lib.optionalString (buildPlatform.isDarwin) ''
    export build_configargs=ac_cv_func_aligned_alloc=no
'' + lib.optionalString (hostPlatform.isDarwin) ''
    export host_configargs=ac_cv_func_aligned_alloc=no
'' + lib.optionalString (targetPlatform.isDarwin) ''
    export target_configargs=ac_cv_func_aligned_alloc=no
''

# In order to properly install libgccjit on macOS Catalina, strip(1)
# upon installation must not remove external symbols, otherwise the
# install step errors with "symbols referenced by indirect symbol
# table entries that can't be stripped".
+ lib.optionalString (hostPlatform.isDarwin && langJit) ''
  export STRIP='strip -x'
''

# HACK: if host and target config are the same, but the platforms are
# actually different we need to convince the configure script that it
# is in fact building a cross compiler although it doesn't believe it.
+ lib.optionalString (targetPlatform.config == hostPlatform.config && targetPlatform != hostPlatform) ''
  substituteInPlace configure --replace is_cross_compiler=no is_cross_compiler=yes
''

# Normally (for host != target case) --without-headers automatically
# enables 'inhibit_libc=true' in gcc's gcc/configure.ac. But case of
# gcc->clang "cross"-compilation manages to evade it: there
# hostPlatform != targetPlatform, hostPlatform.config == targetPlatform.config.
# We explicitly inhibit libc headers use in this case as well.
+ lib.optionalString (targetPlatform != hostPlatform &&
                      withoutTargetLibc &&
                      targetPlatform.config == hostPlatform.config &&
                      (stdenv.cc.isClang || stdenv.targetPlatform.useLLVM)) ''
  export inhibit_libc=true
''

+ lib.optionalString (targetPlatform != hostPlatform && withoutTargetLibc && enableShared)
  (import ./libgcc-buildstuff.nix { inherit lib stdenv; })
