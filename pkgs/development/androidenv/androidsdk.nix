{ stdenv, stdenv_32bit, fetchurl, unzip, makeWrapper
, platformTools, support, platforms, sysimages, addons
, zlib_32bit
, libX11_32bit, libxcb_32bit, libXau_32bit, libXdmcp_32bit, libXext_32bit
, libX11, libXext, libXrender, libxcb, libXau, libXdmcp
, freetype, fontconfig, gtk, atk
}:
{platformVersions, useGoogleAPIs}:

stdenv.mkDerivation {
  name = "android-sdk-21";
  
  src = if (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux")
    then fetchurl {
      url = http://dl.google.com/android/android-sdk_r21-linux.tgz;
      md5 = "7f8d73b629f808cdcfc9f9900bbd7580";
    }
    else if stdenv.system == "x86_64-darwin" then fetchurl {
      url = http://dl.google.com/android/android-sdk_r21-macosx.zip;
      md5 = "67e46adca90dd18d7291443f6c15d6af";
    }
    else throw "platform not ${stdenv.system} supported!";
  
  buildCommand = ''
    mkdir -p $out/libexec
    cd $out/libexec
    unpackFile $src;
    
    cd android-sdk-*/tools
    
    ${stdenv.lib.optionalString (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux")
    ''
      # There are a number of native binaries. We must patch them to let them find the interpreter and libstdc++
    
      for i in dmtracedump emulator emulator-arm emulator-mips emulator-x86 hprof-conv mksdcard sqlite3
      do
          patchelf --set-interpreter ${stdenv_32bit.gcc.libc}/lib/ld-linux.so.2 $i
          patchelf --set-rpath ${stdenv_32bit.gcc.gcc}/lib $i
      done
    
      ${stdenv.lib.optionalString (stdenv.system == "x86_64-linux") ''
        # We must also patch the 64-bit emulator instances, if needed
        
        for i in emulator64-arm emulator64-mips emulator64-x86
        do
            patchelf --set-interpreter ${stdenv.gcc.libc}/lib/ld-linux-x86-64.so.2 $i
            patchelf --set-rpath ${stdenv.gcc.gcc}/lib64 $i
        done
      ''}
      
      # These tools also need zlib in addition to libstdc++
    
      for i in etc1tool zipalign
      do
          patchelf --set-interpreter ${stdenv_32bit.gcc.libc}/lib/ld-linux.so.2 $i
          patchelf --set-rpath ${stdenv_32bit.gcc.gcc}/lib:${zlib_32bit}/lib $i
      done
    
      # The emulators need additional libraries, which are not in the RPATH => let's wrap them
    
      for i in emulator emulator-arm emulator-mips emulator-x86
      do
          wrapProgram `pwd`/$i \
            --prefix LD_LIBRARY_PATH : `pwd`/lib:${libX11_32bit}/lib:${libxcb_32bit}/lib:${libXau_32bit}/lib:${libXdmcp_32bit}/lib:${libXext_32bit}/lib
      done
      
      ${stdenv.lib.optionalString (stdenv.system == "x86_64-linux") ''
        for i in emulator64-arm emulator64-mips emulator64-x86
        do
            wrapProgram `pwd`/$i \
            --prefix LD_LIBRARY_PATH : `pwd`/lib:${libX11}/lib:${libxcb}/lib:${libXau}/lib:${libXdmcp}/lib:${libXext}/lib
        done
      ''}
    ''}

    patchShebangs .
    
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
    
    # Create wrappers to the most important tools and platform tools so that we can run them if the SDK is in our PATH
    
    ensureDir $out/bin

    for i in $out/libexec/android-sdk-*/tools/*
    do
        if [ ! -d $i ] && [ -x $i ]
        then
            ( echo '#! ${stdenv.shell} -e'
              echo "cd $out/libexec/android-sdk-*/tools"
              echo "exec ./$(basename $i) \"\$@\"" ) > $out/bin/$(basename $i)
          
              chmod +x $out/bin/$(basename $i)
        fi
    done
    
    for i in $out/libexec/android-sdk-*/platform-tools/*
    do
        if [ ! -d $i ] && [ -x $i ]
        then
            ( echo '#! ${stdenv.shell} -e'
              echo "cd $out/libexec/android-sdk-*/platform-tools"
              echo "exec ./$(basename $i) \"\$@\"") > $out/bin/$(basename $i)
          
              chmod +x $out/bin/$(basename $i)
        fi
    done
  '';
  
  buildInputs = [ unzip makeWrapper ];
}
