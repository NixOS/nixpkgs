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
