{stdenv, stdenv_32bit, zlib_32bit, fetchurl, unzip}:

stdenv.mkDerivation rec {
  version = "23.0.1";
  name = "android-platform-tools-r${version}";
  src = if (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux")
    then fetchurl {
      url = "https://dl.google.com/android/repository/platform-tools_r${version}-linux.zip";
      sha1 = "94dcc5072b3d0d74cc69e4101958b6c2e227e738";
    }
    else if stdenv.system == "x86_64-darwin" then fetchurl {
      url = "https://dl.google.com/android/repository/platform-tools_r${version}-macosx.zip";
      sha1 = "c461d66f3ca9fbae8ea0fa1a49c203b3b6fd653f";
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
            patchelf --set-interpreter ${stdenv_32bit.cc.libc.out}/lib/ld-linux.so.2 $i
            patchelf --set-rpath ${stdenv_32bit.cc.cc}/lib:`pwd`/lib $i
        done
        
        for i in etc1tool
        do
            patchelf --set-interpreter ${stdenv_32bit.cc.libc}/lib/ld-linux.so.2 $i
            patchelf --set-rpath ${stdenv_32bit.cc.cc}/lib:${zlib_32bit}/lib:`pwd`/lib $i
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
