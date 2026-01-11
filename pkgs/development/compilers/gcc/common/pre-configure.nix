{
  lib,
  stdenv,
  version,
  buildPlatform,
  hostPlatform,
  targetPlatform,
  gnat-bootstrap ? null,
  langAda ? false,
  langFortran,
  langJit ? false,
  langGo,
  withoutTargetLibc,
  enableShared,
  enableMultilib,
  pkgsBuildTarget,
}:

assert langAda -> gnat-bootstrap != null;

lib.optionalString (hostPlatform.isSunOS && hostPlatform.is64bit) ''
  export NIX_LDFLAGS=`echo $NIX_LDFLAGS | sed -e s~$prefix/lib~$prefix/lib/amd64~g`
  export LDFLAGS_FOR_TARGET="-Wl,-rpath,$prefix/lib/amd64 $LDFLAGS_FOR_TARGET"
  export CXXFLAGS_FOR_TARGET="-Wl,-rpath,$prefix/lib/amd64 $CXXFLAGS_FOR_TARGET"
  export CFLAGS_FOR_TARGET="-Wl,-rpath,$prefix/lib/amd64 $CFLAGS_FOR_TARGET"
''
+ lib.optionalString langAda ''
  export PATH=${gnat-bootstrap}/bin:$PATH
''

# For a cross-built native compiler, i.e. build!=(host==target), the
# bundled libgfortran needs a gfortran which can run on the
# buildPlatform and emit code for the targetPlatform.  The compiler
# which is built alongside gfortran in this configuration doesn't
# meet that need: it runs on the hostPlatform.
+
  lib.optionalString
    (
      langFortran
      && (

        (!lib.systems.equals buildPlatform hostPlatform) && (lib.systems.equals hostPlatform targetPlatform)
      )
    )
    ''
      export GFORTRAN_FOR_TARGET=${pkgsBuildTarget.gfortran}/bin/${stdenv.targetPlatform.config}-gfortran
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
+
  lib.optionalString
    (targetPlatform.config == hostPlatform.config && (!lib.systems.equals targetPlatform hostPlatform))
    ''
      substituteInPlace configure --replace is_cross_compiler=no is_cross_compiler=yes
    ''

# Normally (for host != target case) --without-headers automatically
# enables 'inhibit_libc=true' in gcc's gcc/configure.ac. But case of
# gcc->clang or dynamic->static "cross"-compilation manages to evade it: there
# ! lib.systems.equals hostPlatform targetPlatform, hostPlatform.config == targetPlatform.config.
# We explicitly inhibit libc headers use in this case as well.
+
  lib.optionalString
    (
      (!lib.systems.equals targetPlatform hostPlatform)
      && withoutTargetLibc
      && targetPlatform.config == hostPlatform.config
    )
    ''
      export inhibit_libc=true
    ''

+ lib.optionalString (
  (!lib.systems.equals targetPlatform hostPlatform) && withoutTargetLibc && enableShared
) (import ./libgcc-buildstuff.nix { inherit lib stdenv; })
