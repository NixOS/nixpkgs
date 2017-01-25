{stdenv, zlib, fetchurl, unzip}:

stdenv.mkDerivation rec {
  version = "25.0.1";
  name = "android-platform-tools-r${version}";
  src = if (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux")
    then fetchurl {
      url = "https://dl.google.com/android/repository/platform-tools_r${version}-linux.zip";
      sha256 = "0r8ix3jjqpk6wyxm8f6az9r4z5a1lnb3b9hzh8ay4ayidwhn8isx";
    }
    else if stdenv.system == "x86_64-darwin" then fetchurl {
      url = "https://dl.google.com/android/repository/platform-tools_r${version}-macosx.zip";
      sha256 = "18pzwpr6fbxlw782j65clwz9kvdgvb04jpr2z12bbwyd8wqc4yln";
    }
    else throw "System ${stdenv.system} not supported!";

  buildCommand = ''
    mkdir -p $out
    cd $out
    unzip $src
    cd platform-tools
    
    ${stdenv.lib.optionalString (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux")
      ''
        for i in adb dmtracedump fastboot hprof-conv sqlite3
        do
            patchelf --set-interpreter ${stdenv.cc.libc.out}/lib/ld-linux-x86-64.so.2 $i
            patchelf --set-rpath ${stdenv.cc.cc.lib}/lib:`pwd`/lib64 $i
        done
        
        for i in etc1tool
        do
            patchelf --set-interpreter ${stdenv.cc.libc.out}/lib/ld-linux-x86-64.so.2 $i
            patchelf --set-rpath ${stdenv.cc.cc.lib}/lib:${zlib.out}/lib:`pwd`/lib64 $i
        done
    ''}

    mkdir -p $out/bin
    for i in adb fastboot
    do
        ln -sf $out/platform-tools/$i $out/bin/$i
    done
  '';
  
  buildInputs = [ unzip ];
}
