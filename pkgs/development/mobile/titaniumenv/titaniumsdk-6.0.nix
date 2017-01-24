{stdenv, fetchurl, unzip, makeWrapper, python, jdk}:

stdenv.mkDerivation {
  name = "mobilesdk-6.0.2.GA";
  src = if (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux") then fetchurl {
    url = http://builds.appcelerator.com/mobile/6_0_X/mobilesdk-6.0.2.v20170123140026-linux.zip;
    sha256 = "1yjhr4fgjnxfxzwmgw71yynrfzhsjqj2cirjr5rd14zlp4q9751q";
  }
  else if stdenv.system == "x86_64-darwin" then fetchurl {
    url = http://builds.appcelerator.com/mobile/6_0_X/mobilesdk-6.0.2.v20170123140026-osx.zip;
    sha256 = "1ijd1wp56ygy238xpcffy112akim208wbv5zm901dvych83ibw1c";
  }
  else throw "Platform: ${stdenv.system} not supported!";
  
  buildInputs = [ unzip makeWrapper ];
  
  buildCommand = ''
    mkdir -p $out
    cd $out
    (yes y | unzip $src) || true
    
    # Rename ugly version number
    cd mobilesdk/*
    mv * 6.0.2.GA
    cd *
    
    # Patch some executables
    
    ${if stdenv.system == "i686-linux" then
      ''
        patchelf --set-interpreter ${stdenv.cc.libc}/lib/ld-linux.so.2 android/titanium_prep.linux32
      ''
      else if stdenv.system == "x86_64-linux" then
      ''
        patchelf --set-interpreter ${stdenv.cc.libc}/lib/ld-linux-x86-64.so.2 android/titanium_prep.linux64
      ''
      else ""}
  '';
}
