{ fetchFromGitHub, runCommand, stdenv, llvm, lld, version }:

let
  # Wrappers that implement some functionality before upstream has it.
  llvm-mingw = stdenv.mkDerivation rec {
    name = "llvm-mingw";
    version = "git-${src.rev}";
    src = fetchFromGitHub {
      repo = "llvm-mingw";
      owner = "mstorsjo";
      rev = "5d764329d80fe6f0ae3f067d0b606062eb466712";
      sha256 = "0q3vmjjjrmlpdnqg9b81x4797kvhdbn6yhlambfjnvk4pzi7hglv";
    };
    postUnpack = ''
      sourceRoot=''${sourceRoot}/wrappers;
    '';
    buildPhase = ''
      $CC -iquote . windres-wrapper.c -o llvm-windres
    '';
    #buildPhase = ''
    #  $CC -iquote . windres-wrapper.c -DLLVM_PATH=\"${llvm}/bin/\" -o llvm-windres
    #'';
    installPhase = ''
      mkdir -p "$out/bin"
      install -m 755 llvm-windres "$out/bin"
    '';
  };
  prefix =
    if stdenv.hostPlatform != stdenv.targetPlatform
    then "${stdenv.targetPlatform.config}-"
    else "";
in runCommand "llvm-binutils-${version}" { preferLocalBuild = true; } ''
   mkdir -p $out/bin
   for prog in ${lld}/bin/*; do
     ln -s $prog $out/bin/${prefix}$(basename $prog)
   done
   for prog in ${llvm}/bin/* ${llvm-mingw}/bin/*; do
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
