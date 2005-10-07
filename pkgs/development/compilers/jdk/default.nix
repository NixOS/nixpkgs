args:

if args.stdenv.system == "i686-linux"
  then
    (import ./jdk5-sun-linux.nix) args
  else
    false
