{stdenv, fetchurl, unzip, makeWrapper}:

stdenv.mkDerivation {
  name = "mobilesdk-6.3.1.GA";
  src = if (stdenv.hostPlatform.system == "i686-linux" || stdenv.hostPlatform.system == "x86_64-linux") then fetchurl {
    url = http://builds.appcelerator.com/mobile/6_3_X/mobilesdk-6.3.1.v20171101154403-linux.zip;
    sha256 = "0g8dqqf5ffa7ll3rqm5naywipnv2vvfxcj9fmqg1wnvvxf0rflqj";
  }
  else if stdenv.hostPlatform.system == "x86_64-darwin" then fetchurl {
    url = http://builds.appcelerator.com/mobile/6_3_X/mobilesdk-6.3.1.v20171101154403-osx.zip;
    sha256 = "00bm8vv70mg4kd7jvmxd1bfqafv6zdpdx816i0hvf801zwnak4nj";
  }
  else throw "Platform: ${stdenv.hostPlatform.system} not supported!";
  
  buildInputs = [ unzip makeWrapper ];
  
  buildCommand = ''
    mkdir -p $out
    cd $out
    (yes y | unzip $src) || true
    
    # Rename ugly version number
    cd mobilesdk/*
    mv * 6.3.1.GA
    cd *
    ${stdenv.lib.optionalString (stdenv.hostPlatform.system == "x86_64-darwin") ''
      # Fixes a bad archive copying error when generating an IPA file
      sed -i -e "s|cp -rf|/bin/cp -rf|" iphone/cli/commands/_build.js
    ''}

    # Patch some executables
    
    ${if stdenv.hostPlatform.system == "i686-linux" then
      ''
        patchelf --set-interpreter ${stdenv.cc.libc}/lib/ld-linux.so.2 android/titanium_prep.linux32
      ''
      else if stdenv.hostPlatform.system == "x86_64-linux" then
      ''
        patchelf --set-interpreter ${stdenv.cc.libc}/lib/ld-linux-x86-64.so.2 android/titanium_prep.linux64
      ''
      else ""}
  '';
}
