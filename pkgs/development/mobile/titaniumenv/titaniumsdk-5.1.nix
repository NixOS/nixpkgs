{stdenv, fetchurl, unzip, makeWrapper, python, jdk}:

stdenv.mkDerivation {
  name = "mobilesdk-5.1.1.GA";
  src = if (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux") then fetchurl {
    url = http://builds.appcelerator.com/mobile/5_1_1/mobilesdk-5.1.1.v20151203123251-linux.zip;
    sha256 = "197pia5a0bacwwyi0s7s69iyx4i2jdrgjc3ybiahaqv27dhw9zr2";
  }
  else if stdenv.system == "x86_64-darwin" then fetchurl {
    url = http://builds.appcelerator.com/mobile/5_1_1/mobilesdk-5.1.1.v20151203123251-osx.zip;
    sha256 = "1ij2zc5450fnl13w8ia1z6pa12vja6ks1ssvlb73n2rx52krgvxr";
  }
  else throw "Platform: ${stdenv.system} not supported!";
  
  buildInputs = [ unzip makeWrapper ];
  
  buildCommand = ''
    mkdir -p $out
    cd $out
    (yes y | unzip $src) || true
    
    # Rename ugly version number
    cd mobilesdk/*
    mv * 5.1.1.GA
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
