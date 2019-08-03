{ runCommand, stdenv, llvm, lld, version }:

let
  prefix =
    if stdenv.hostPlatform != stdenv.targetPlatform
    then "${stdenv.targetPlatform.config}-"
    else "";
in runCommand "llvm-binutils-${version}" { preferLocalBuild = true; } ''
   mkdir -p $out/bin
   for prog in ${lld}/bin/*; do
     ln -s $prog $out/bin/${prefix}$(basename $prog)
   done
   for prog in ${llvm}/bin/*; do
     ln -s $prog $out/bin/${prefix}$(echo $(basename $prog) | sed -e "s|llvm-||")
     ln -sf $prog $out/bin/${prefix}$(basename $prog)
   done
   rm -f $out/bin/${prefix}cat
   ln -s ${lld}/bin/lld $out/bin/${prefix}ld
''
