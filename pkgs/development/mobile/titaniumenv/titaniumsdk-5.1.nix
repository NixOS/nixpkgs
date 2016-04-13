{stdenv, fetchurl, unzip, makeWrapper, python, jdk}:

stdenv.mkDerivation {
  name = "mobilesdk-5.1.2.GA";
  src = if (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux") then fetchurl {
    url = http://builds.appcelerator.com/mobile/5_1_X/mobilesdk-5.1.2.v20151216190036-linux.zip;
    sha256 = "013ipqwkfqj60mn09jbbf6a9mc4pjrn0kr0ix906whzb888zz6bv";
  }
  else if stdenv.system == "x86_64-darwin" then fetchurl {
    url = http://builds.appcelerator.com/mobile/5_1_X/mobilesdk-5.1.2.v20151216190036-osx.zip;
    sha256 = "1ylwh7zxa5yfyckzn3a9zc4cmh8gdndgb3jyr61s3j7zb1whn9ww";
  }
  else throw "Platform: ${stdenv.system} not supported!";
  
  buildInputs = [ unzip makeWrapper ];
  
  buildCommand = ''
    mkdir -p $out
    cd $out
    (yes y | unzip $src) || true
    
    # Rename ugly version number
    cd mobilesdk/*
    mv * 5.1.2.GA
    cd *
    
    # Hack to make dx.jar work with new build-tools
    sed -i -e "s|path.join(dir, 'platform-tools', 'lib', 'dx.jar')|path.join(dir, 'build-tools', 'android-6.0', 'lib', 'dx.jar')|" $out/mobilesdk/*/*/node_modules/titanium-sdk/lib/android.js
    
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
