{ stdenv, stdenv_32bit, fetchurl, unzip, shebangfix, makeWrapper
, platformTools, support, platforms, sysimages, addons
, zlib_32bit
, libX11_32bit, libxcb_32bit, libXau_32bit, libXdmcp_32bit, libXext_32bit
, libX11, libXext, libXrender
, freetype, fontconfig, gtk, atk
}:
{platformVersions, useGoogleAPIs}:

stdenv.mkDerivation {
  name = "android-sdk-linux-20.0.3";
  
  src = if (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux")
    then fetchurl {
      url = http://dl.google.com/android/android-sdk_r20.0.3-linux.tgz;
      sha256 = "0xfb41xsjaf7n6b9gsrxm24jwg2fi1hzn73y69rlqm55bw1vxhc1";
    }
    else if stdenv.system == "x86_64-darwin" then fetchurl {
      url = http://dl.google.com/android/android-sdk_r20.0.3-macosx.zip;
      sha256 = "0eecaa04950d5c540f36ab4183a4cbaef3ae6a7434467bfc32febaeb796a8ff2";
    }
    else throw "platform not ${stdenv.system} supported!";
  
  buildCommand = ''
    mkdir -p $out
    cd $out
    unpackFile $src;
    
    cd android-sdk-*/tools
    
    ${stdenv.lib.optionalString (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux")
    ''
      # There are a number of native binaries. We must patch them to let them find the interpreter and libstdc++
    
      for i in dmtracedump emulator emulator-arm emulator-x86 hprof-conv mksdcard sqlite3
      do
          patchelf --set-interpreter ${stdenv_32bit.gcc.libc}/lib/ld-linux.so.2 $i
          patchelf --set-rpath ${stdenv_32bit.gcc.gcc}/lib $i
      done
    
      # These tools also need zlib in addition to libstdc++
    
      for i in etc1tool zipalign
      do
          patchelf --set-interpreter ${stdenv_32bit.gcc.libc}/lib/ld-linux.so.2 $i
          patchelf --set-rpath ${stdenv_32bit.gcc.gcc}/lib:${zlib_32bit}/lib $i
      done
    
      # The emulators need additional libraries, which are not in the RPATH => let's wrap them
    
      for i in emulator emulator-arm emulator-x86
      do
          wrapProgram `pwd`/$i \
            --prefix LD_LIBRARY_PATH : `pwd`/lib:${libX11_32bit}/lib:${libxcb_32bit}/lib:${libXau_32bit}/lib:${libXdmcp_32bit}/lib:${libXext_32bit}/lib
      done
    ''}
    
    # These are shell scripts with a reference to #!/bin/bash, which must be patched
    
    for i in ddms draw9patch monkeyrunner monitor lint traceview
    do
        shebangfix $i
    done

    ${if stdenv.system == "i686-linux" then
      ''
        # The monitor requires some more patching
        
        cd lib/monitor-x86
        patchelf --set-interpreter ${stdenv.gcc.libc}/lib/ld-linux.so.2 monitor
        patchelf --set-rpath ${libX11}/lib:${libXext}/lib:${libXrender}/lib:${freetype}/lib:${fontconfig}/lib libcairo-swt.so
        
        wrapProgram `pwd`/monitor \
          --prefix LD_LIBRARY_PATH : ${gtk}/lib:${atk}/lib:${stdenv.gcc.gcc}/lib

        cd ../..
      ''
      else if stdenv.system == "x86_64-linux" then
      ''
        # The monitor requires some more patching
        
        cd lib/monitor-x86_64
        patchelf --set-interpreter ${stdenv.gcc.libc}/lib/ld-linux-x86-64.so.2 monitor
        patchelf --set-rpath ${libX11}/lib:${libXext}/lib:${libXrender}/lib:${freetype}/lib:${fontconfig}/lib libcairo-swt.so
        
        wrapProgram `pwd`/monitor \
          --prefix LD_LIBRARY_PATH : ${gtk}/lib:${atk}/lib:${stdenv.gcc.gcc}/lib

        cd ../..
      ''
      else ""}
    
    # Symlink the other sub packages
    
    cd ..
    ln -s ${platformTools}/platform-tools
    ln -s ${support}/support
    
    # Symlink required Google API add-ons
    
    mkdir -p add-ons
    cd add-ons
    
    ${if useGoogleAPIs then
        stdenv.lib.concatMapStrings (platformVersion:
        if (builtins.hasAttr ("google_apis_"+platformVersion) addons) then
          let
            googleApis = builtins.getAttr ("google_apis_"+platformVersion) addons;
          in
          "ln -s ${googleApis}/* addon-google_apis-${platformVersion}"
        else "") platformVersions
      else ""}
      
    cd ..

    # Symlink required platforms
   
    mkdir -p platforms
    cd platforms
    
    ${stdenv.lib.concatMapStrings (platformVersion:
      if (builtins.hasAttr ("platform_"+platformVersion) platforms) then
        let
          platform = builtins.getAttr ("platform_"+platformVersion) platforms;
        in
        "ln -s ${platform}/* android-${platformVersion}"
      else ""
    ) platformVersions}
    
    cd ..
    
    # Symlink required system images
  
    mkdir -p system-images
    cd system-images
    
    ${stdenv.lib.concatMapStrings (platformVersion:
      if (builtins.hasAttr ("sysimg_"+platformVersion) sysimages) then
        let
          sysimg = builtins.getAttr ("sysimg_"+platformVersion) sysimages;
        in
        ''
          mkdir -p android-${platformVersion}
          cd android-${platformVersion}
          ln -s ${sysimg}/*
          cd ..
        ''
      else ""
    ) platformVersions}
  '';
  
  buildInputs = [ shebangfix unzip makeWrapper ];
}
