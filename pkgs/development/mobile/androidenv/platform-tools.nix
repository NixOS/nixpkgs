{stdenv, stdenv_32bit, fetchurl, unzip}:

let
  version = "22";

in

stdenv.mkDerivation {
  name = "android-platform-tools-r${version}";
  src = if (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux")
    then fetchurl {
      url = "https://dl-ssl.google.com/android/repository/platform-tools_r${version}-linux.zip";
      sha256 = "1kbp5fzfdas6c431n53a9w0z0182ihhadd1h8a64m1alkw0swr41";
    }
    else if stdenv.system == "x86_64-darwin" then fetchurl {
      url = "https://dl-ssl.google.com/android/repository/platform-tools_r${version}-macosx.zip";
      sha256 = "0r359xxicn7zw9z0jbrmsppx1372fijg09ck907gg8x1cvzj2ry0";
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
            patchelf --set-interpreter ${stdenv_32bit.cc.libc.out}/lib/ld-linux.so.2 $i
            patchelf --set-rpath ${stdenv_32bit.cc.cc}/lib $i
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
