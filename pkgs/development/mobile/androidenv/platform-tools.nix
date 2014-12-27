{stdenv, stdenv_32bit, fetchurl, unzip}:

let
  version = "21";

in

stdenv.mkDerivation {
  name = "android-platform-tools-r${version}";
  src = if (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux")
    then fetchurl {
      url = "https://dl-ssl.google.com/android/repository/platform-tools_r${version}-linux.zip";
      sha256 = "35a1762b355451e000a816d97d9af640ca99ae6c5b5b406a3e680210af8106ad";
    }
    else if stdenv.system == "x86_64-darwin" then fetchurl {
      url = "https://dl-ssl.google.com/android/repository/platform-tools_r${version}-macosx.zip";
      sha256 = "30ae8724da3db772a776d616b4746516f24ae81330e84315a7ce0c49e0b0b3cb";
    }
    else throw "System ${stdenv.system} not supported!";

  buildCommand = ''
    mkdir -p $out
    cd $out
    unzip $src
    cd platform-tools
    
    ${stdenv.lib.optionalString (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux")
      ''
        for i in adb fastboot
        do
            patchelf --set-interpreter ${stdenv_32bit.cc.libc}/lib/ld-linux.so.2 $i
            patchelf --set-rpath ${stdenv_32bit.cc.gcc}/lib $i
        done
    ''}
  '';
  
  buildInputs = [ unzip ];
}
