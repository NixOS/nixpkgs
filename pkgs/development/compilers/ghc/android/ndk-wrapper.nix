{ stdenv, androidndk, makeWrapper }:

stdenv.mkDerivation {
     name = "ndk-wrapper";
     buildInputs = [ makeWrapper ];
     propagatedBuildInputs = [ androidndk ];
     unpackPhase = "true";
     installPhase = ''
       mkdir -p $out/bin
       makeWrapper ${androidndk}/libexec/${androidndk.name}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-gcc $out/bin/arm-linux-androideabi-gcc --add-flags --sysroot=${androidndk}/libexec/${androidndk.name}/platforms/android-21/arch-arm
       makeWrapper ${androidndk}/libexec/${androidndk.name}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-cpp $out/bin/arm-linux-androideabi-cpp  --add-flags --sysroot=${androidndk}/libexec/${androidndk.name}/platforms/android-21/arch-arm
       makeWrapper ${androidndk}/libexec/${androidndk.name}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-g++ $out/bin/arm-linux-androideabi-g++  --add-flags --sysroot=${androidndk}/libexec/${androidndk.name}/platforms/android-21/arch-arm
       makeWrapper ${androidndk}/libexec/${androidndk.name}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-ld $out/bin/arm-linux-androideabi-ld
       makeWrapper ${androidndk}/libexec/${androidndk.name}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-ld.gold $out/bin/arm-linux-androideabi-ld.gold
       makeWrapper ${androidndk}/libexec/${androidndk.name}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-nm $out/bin/arm-linux-androideabi-nm
       makeWrapper ${androidndk}/libexec/${androidndk.name}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-ar $out/bin/arm-linux-androideabi-ar
       makeWrapper ${androidndk}/libexec/${androidndk.name}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-ranlib $out/bin/arm-linux-androideabi-ranlib

       makeWrapper ${androidndk}/libexec/${androidndk.name}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-strip $out/bin/arm-linux-androideabi-strip       
       makeWrapper ${androidndk}/libexec/${androidndk.name}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-gcc-ar $out/bin/arm-linux-androideabi-gcc-ar
       makeWrapper ${androidndk}/libexec/${androidndk.name}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-gcc-nm $out/bin/arm-linux-androideabi-gcc-nm
       makeWrapper ${androidndk}/libexec/${androidndk.name}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-gcc-ranlib $out/bin/arm-linux-androideabi-gcc-ranlib
     '';
   }

