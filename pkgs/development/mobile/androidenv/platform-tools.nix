{stdenv, stdenv_32bit, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "android-platform-tools-r18.0.1";
  src = if (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux")
    then fetchurl {
      url = https://dl-ssl.google.com/android/repository/platform-tools_r18.0.1-linux.zip;
      sha1 = "cf9bdbbaa34da37b59724f914dad907c2c74a387";
    }
    else if stdenv.system == "x86_64-darwin" then fetchurl {
      url = https://dl-ssl.google.com/android/repository/platform-tools_r18.0.1-macosx.zip;
      sha1 = "126325cbb55928c38acbb9c7bb5d9145d94fad56";
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
