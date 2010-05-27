args:

if args.stdenv.system == "i686-linux" || args.stdenv.system == "x86_64-linux" then
  (import ./jdk6-linux.nix) ( removeAttrs args ["cabextract"] )
else if args.stdenv.system == "powerpc-linux" then
  (import ./jdk5-ibm-powerpc-linux.nix) (removeAttrs args ["pluginSupport" "xlibs" "installjdk" "cabextract"])
else if args.stdenv.system == "i686-cygwin" then
  (import ./jdk6-cygwin.nix) (removeAttrs args ["pluginSupport" "xlibs" "installjdk" "xlibs"])
else
  abort "the JDK is not supported on this platform"

