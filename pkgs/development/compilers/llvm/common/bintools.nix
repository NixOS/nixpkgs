{
  lib,
  runCommand,
  stdenv,
  llvm,
  lld,
  version,
  release_version,
}:

let
  targetPrefix = lib.optionalString (
    stdenv.hostPlatform != stdenv.targetPlatform
  ) "${stdenv.targetPlatform.config}-";
in
runCommand "llvm-binutils-${version}"
  {
    preferLocalBuild = true;
    passthru = {
      isLLVM = true;
      inherit targetPrefix;
      inherit llvm lld;
    };
  }
  ''
    mkdir -p $out/bin
    for prog in ${lld}/bin/*; do
      ln -s $prog $out/bin/${targetPrefix}$(basename $prog)
    done
    for prog in ${llvm}/bin/*; do
      ln -sf $prog $out/bin/${targetPrefix}$(basename $prog)
    done

    llvmBin="${llvm}/bin"

    ln -s $llvmBin/llvm-ar $out/bin/${targetPrefix}ar
    ln -s $llvmBin/llvm-ar $out/bin/${targetPrefix}dlltool
    ln -s $llvmBin/llvm-ar $out/bin/${targetPrefix}ranlib
    ln -s $llvmBin/llvm-cxxfilt $out/bin/${targetPrefix}c++filt
    ln -s $llvmBin/llvm-dwp $out/bin/${targetPrefix}dwp
    ln -s $llvmBin/llvm-nm $out/bin/${targetPrefix}nm
    ln -s $llvmBin/llvm-objcopy $out/bin/${targetPrefix}objcopy
    ln -s $llvmBin/llvm-objcopy $out/bin/${targetPrefix}strip
    ln -s $llvmBin/llvm-objdump $out/bin/${targetPrefix}objdump
    ln -s $llvmBin/llvm-readobj $out/bin/${targetPrefix}readelf
    ln -s $llvmBin/llvm-size $out/bin/${targetPrefix}size
    ln -s $llvmBin/llvm-strings $out/bin/${targetPrefix}strings
    ln -s $llvmBin/llvm-symbolizer $out/bin/${targetPrefix}addr2line

    if [ -e "$llvmBin/llvm-debuginfod" ]; then
      ln -s $llvmBin/llvm-debuginfod $out/bin/${targetPrefix}debuginfod
      ln -s $llvmBin/llvm-debuginfod-find $out/bin/${targetPrefix}debuginfod-find
    fi

    ln -s ${lld}/bin/lld $out/bin/${targetPrefix}ld

    # Only >=13 show GNU windres compatible in help
    ln -s $llvmBin/llvm-rc $out/bin/${targetPrefix}windres
  ''
