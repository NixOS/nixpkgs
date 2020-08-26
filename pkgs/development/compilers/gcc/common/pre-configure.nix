{ lib, version, hostPlatform
, gnatboot ? null
, langAda ? false
, langJava ? false
, langGo }:

assert langJava -> lib.versionOlder version "7";
assert langAda -> gnatboot != null;

lib.optionalString (hostPlatform.isSunOS && hostPlatform.is64bit) ''
  export NIX_LDFLAGS=`echo $NIX_LDFLAGS | sed -e s~$prefix/lib~$prefix/lib/amd64~g`
  export LDFLAGS_FOR_TARGET="-Wl,-rpath,$prefix/lib/amd64 $LDFLAGS_FOR_TARGET"
  export CXXFLAGS_FOR_TARGET="-Wl,-rpath,$prefix/lib/amd64 $CXXFLAGS_FOR_TARGET"
  export CFLAGS_FOR_TARGET="-Wl,-rpath,$prefix/lib/amd64 $CFLAGS_FOR_TARGET"
'' + lib.optionalString (lib.versionOlder version "7" && (langJava || langGo)) ''
  export lib=$out;
'' + lib.optionalString langAda ''
  export PATH=${gnatboot}/bin:$PATH
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
#  - If Nix used the same libary binaries for each MacOS version, aligned_alloc
#    would not be in the library binaries.
#  - If Catalina did not include aligned_alloc, this wouldn't be a problem.
#  - If the configure scripts looked for header presence as well as
#    linkability, they would see that aligned_alloc is missing.
#  - If GCC allowed implicit declaration of symbols, it would not fail during
#    compilation even if the configure scripts did not check header presence.
#
+ lib.optionalString (hostPlatform.isDarwin) ''
  export ac_cv_func_aligned_alloc=no
''
