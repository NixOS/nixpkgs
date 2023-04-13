{ lib, version, buildPlatform, hostPlatform, targetPlatform
, gnatboot ? null
, langAda ? false
, langJava ? false
, langJit ? false
, langGo
, crossStageStatic
, enableMultilib
}:

assert langJava -> lib.versionOlder version "7";
assert langAda -> gnatboot != null; let
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
  export PATH=${gnatboot}/bin:$PATH
''

# On x86_64-darwin, the gnatboot bootstrap compiler that we need to build a
# native GCC with Ada support emits assembly that is accepted by the Clang
# integrated assembler, but not by the GNU assembler in cctools-port that Nix
# usually in the x86_64-darwin stdenv.  In particular, x86_64-darwin gnatboot
# emits MOVQ as the mnemonic for quadword interunit moves, such as between XMM
# and general registers (e.g "movq %xmm0, %rbp"); the cctools-port assembler,
# however, only recognises MOVD for such moves.
#
# Therefore, for native x86_64-darwin builds that support Ada, we have to use
# the Clang integrated assembler to build (at least stage 1 of) GCC, but have to
# target GCC at the cctools-port GNU assembler.  In the wrapped x86_64-darwin
# gnatboot, the former is provided as `as`, while the latter is provided as
# `gas`.
#
+ lib.optionalString (
    langAda
    && buildPlatform == hostPlatform
    && hostPlatform == targetPlatform
    && targetPlatform.isx86_64
    && targetPlatform.isDarwin
  ) ''
  export AS_FOR_BUILD=${gnatboot}/bin/as
  export AS_FOR_TARGET=${gnatboot}/bin/gas
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
+ lib.optionalString (targetPlatform != hostPlatform && crossStageStatic) ''
  export inhibit_libc=true
''

+ lib.optionalString (!enableMultilib && hostPlatform.is64bit && !hostPlatform.isMips64n32) ''
  export linkLib64toLib=1
''

# On mips platforms, gcc follows the IRIX naming convention:
#
#  $PREFIX/lib   = mips32
#  $PREFIX/lib32 = mips64n32
#  $PREFIX/lib64 = mips64
#
+ lib.optionalString (!enableMultilib && targetPlatform.isMips64n32) ''
  export linkLib32toLib=1
''
