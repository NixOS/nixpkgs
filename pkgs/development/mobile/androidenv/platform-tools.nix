{stdenv, zlib, fetchurl, unzip}:

stdenv.mkDerivation rec {
  version = "24.0.2";
  name = "android-platform-tools-r${version}";
  src = if (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux")
    then fetchurl {
      url = "https://dl.google.com/android/repository/platform-tools_r${version}-linux.zip";
      sha256 = "0y36mlwh4kb77d3vcpqxqwkxsadllap6g6jjylf3rb7blh5l4zw6";
    }
    else if stdenv.system == "x86_64-darwin" then fetchurl {
      url = "https://dl.google.com/android/repository/platform-tools_r${version}-macosx.zip";
      sha256 = "1whfhdwjir2sv2pfypagva813yn0fx8idi6c2mxhddv2mlws6zk4";
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
