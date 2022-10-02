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
     ln -sf $prog $out/bin/${prefix}$(basename $prog)
   done

   ln -s ${llvm}/bin/llvm-ar $out/bin/${prefix}ar
   ln -s ${llvm}/bin/llvm-as $out/bin/${prefix}as
   ln -s ${llvm}/bin/llvm-dwp $out/bin/${prefix}dwp
   ln -s ${llvm}/bin/llvm-nm $out/bin/${prefix}nm
   ln -s ${llvm}/bin/llvm-objcopy $out/bin/${prefix}objcopy
   ln -s ${llvm}/bin/llvm-objdump $out/bin/${prefix}objdump
   ln -s ${llvm}/bin/llvm-ranlib $out/bin/${prefix}ranlib
   ln -s ${llvm}/bin/llvm-readelf $out/bin/${prefix}readelf
   ln -s ${llvm}/bin/llvm-size $out/bin/${prefix}size
   ln -s ${llvm}/bin/llvm-strip $out/bin/${prefix}strip

   ln -s ${lld}/bin/lld $out/bin/${prefix}ld
''
