args:

if args.stdenv.system == "i686-linux"  then
  (import ./jdk6-linux.nix) args

else if args.stdenv.system == "powerpc-linux"  then
 (import ./jdk5-ibm-powerpc-linux.nix) args

else
  false
