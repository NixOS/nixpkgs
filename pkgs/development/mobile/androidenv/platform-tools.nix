{stdenv, stdenv_32bit, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "android-platform-tools-r19";
  src = if (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux")
    then fetchurl {
      url = https://dl-ssl.google.com/android/repository/platform-tools_r19-linux.zip;
      sha1 = "66ee37daf8a2a8f1aa8939ccd4093658e30aa49b";
    }
    else if stdenv.system == "x86_64-darwin" then fetchurl {
      url = https://dl-ssl.google.com/android/repository/platform-tools_r19-macosx.zip;
      sha1 = "69af30f488163dfc3da8cef1bb6cc7e8a6df5681";
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
            patchelf --set-interpreter ${stdenv_32bit.gcc.libc}/lib/ld-linux.so.2 $i
            patchelf --set-rpath ${stdenv_32bit.gcc.gcc}/lib $i
        done
    ''}
  '';
  
  buildInputs = [ unzip ];
}
