{ lib, runCommand, stdenv, llvm, lld, version, release_version }:

let
  prefix = lib.optionalString (stdenv.hostPlatform != stdenv.targetPlatform) "${stdenv.targetPlatform.config}-";
in runCommand "llvm-binutils-${version}" {
  preferLocalBuild = true;
  passthru = {
    isLLVM = true;
  };
} (''
   mkdir -p $out/bin
   for prog in ${lld}/bin/*; do
     ln -s $prog $out/bin/${prefix}$(basename $prog)
   done
   for prog in ${llvm}/bin/*; do
     ln -sf $prog $out/bin/${prefix}$(basename $prog)
   done

   llvmBin="${llvm}/bin"

   ln -s $llvmBin/llvm-ar $out/bin/${prefix}ar
   ln -s $llvmBin/llvm-ar $out/bin/${prefix}dlltool
   ln -s $llvmBin/llvm-ar $out/bin/${prefix}ranlib
   ln -s $llvmBin/llvm-cxxfilt $out/bin/${prefix}c++filt
   ln -s $llvmBin/llvm-dwp $out/bin/${prefix}dwp
   ln -s $llvmBin/llvm-nm $out/bin/${prefix}nm
   ln -s $llvmBin/llvm-objcopy $out/bin/${prefix}objcopy
   ln -s $llvmBin/llvm-objcopy $out/bin/${prefix}strip
   ln -s $llvmBin/llvm-objdump $out/bin/${prefix}objdump
   ln -s $llvmBin/llvm-readobj $out/bin/${prefix}readelf
   ln -s $llvmBin/llvm-size $out/bin/${prefix}size
   ln -s $llvmBin/llvm-strings $out/bin/${prefix}strings
   ln -s $llvmBin/llvm-symbolizer $out/bin/${prefix}addr2line

   if [ -e "$llvmBin/llvm-debuginfod" ]; then
     ln -s $llvmBin/llvm-debuginfod $out/bin/${prefix}debuginfod
     ln -s $llvmBin/llvm-debuginfod-find $out/bin/${prefix}debuginfod-find
   fi

   ln -s ${lld}/bin/lld $out/bin/${prefix}ld

   # Only >=13 show GNU windres compatible in help
'' + lib.optionalString (lib.versionAtLeast release_version "13") ''
   ln -s $llvmBin/llvm-rc $out/bin/${prefix}windres
'')
