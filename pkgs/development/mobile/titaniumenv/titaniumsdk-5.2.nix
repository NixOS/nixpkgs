{stdenv, fetchurl, unzip, makeWrapper, python, jdk}:

stdenv.mkDerivation {
  name = "mobilesdk-5.2.3.GA";
  src = if (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux") then fetchurl {
    url = http://builds.appcelerator.com/mobile/5_2_X/mobilesdk-5.2.3.v20160404160237-linux.zip;
    sha256 = "1acvkj3nrkgf9ch4js0pnjnwq5x6ddc15pkcanshp1zlc41z16gj";
  }
  else if stdenv.system == "x86_64-darwin" then fetchurl {
    url = http://builds.appcelerator.com/mobile/5_2_X/mobilesdk-5.2.3.v20160404160237-osx.zip;
    sha256 = "04l7mrwiy3il2kzxz6sbfmczkqlkcrnwwndfzi8h5dzgh1672b7d";
  }
  else throw "Platform: ${stdenv.system} not supported!";
  
  buildInputs = [ unzip makeWrapper ];
  
  buildCommand = ''
    mkdir -p $out
    cd $out
    (yes y | unzip $src) || true
    
    # Rename ugly version number
    cd mobilesdk/*
    mv * 5.2.3.GA
    cd *
    
    # Hack to make dx.jar work with new build-tools
    #sed -i -e "s|path.join(dir, 'platform-tools', 'lib', 'dx.jar')|path.join(dir, 'build-tools', 'android-6.0', 'lib', 'dx.jar')|" $out/mobilesdk/*/*/node_modules/titanium-sdk/lib/android.js
    
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
