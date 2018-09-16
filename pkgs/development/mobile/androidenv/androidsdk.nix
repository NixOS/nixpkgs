{ stdenv, stdenv_32bit, fetchurl, fetchzip, unzip, makeWrapper
, platformTools, buildTools, support, supportRepository, platforms, sysimages, addons, sources
, libX11, libXext, libXrender, libxcb, libXau, libXdmcp, libXtst, libGLU_combined, alsaLib
, freetype, fontconfig, glib, gtk2, atk, file, jdk, coreutils, libpulseaudio, dbus
, zlib, glxinfo, xkeyboardconfig
, includeSources
}:
{ platformVersions, abiVersions, useGoogleAPIs, useExtraSupportLibs ? false
, useGooglePlayServices ? false, useInstantApps ? false }:

let inherit (stdenv.lib) makeLibraryPath;

    googleRepository = let version = "gms_v9_rc41_wear_2_0_rc6";
      in fetchzip rec {
        url = "https://dl-ssl.google.com/android/repository/google_m2repository_${version}.zip";
        sha256 = "0k99xmynv0k62d301zx5jnjkddflr51i5lb02l9incg7m5cn8kzx";
      };

in

stdenv.mkDerivation rec {
  name = "android-sdk-${version}";
  version = "25.2.5";

  src = if (stdenv.hostPlatform.system == "i686-linux" || stdenv.hostPlatform.system == "x86_64-linux")
    then fetchurl {
      url = "https://dl.google.com/android/repository/tools_r${version}-linux.zip";
      sha256 = "0gnk49pkwy4m0nqwm1xnf3w4mfpi9w0kk7841xlawpwbkj0icxap";
    }
    else if stdenv.hostPlatform.system == "x86_64-darwin" then fetchurl {
      url = "http://dl.google.com/android/repository/tools_r${version}-macosx.zip";
      sha256 = "0yg7wjmyw70xsh8k4hgbqb5rilam2a94yc8dwbh7fjwqcmpxgwqb";
    }
    else throw "platform not ${stdenv.hostPlatform.system} supported!";

  buildCommand = ''
    mkdir -p $out/libexec
    cd $out/libexec
    unpackFile $src
    cd tools

    for f in android traceview draw9patch hierarchyviewer monitor ddms screenshot2 uiautomatorviewer monkeyrunner jobb lint
    do
        sed -i -e "s|/bin/ls|${coreutils}/bin/ls|" "$f"
    done

    ${stdenv.lib.optionalString (stdenv.hostPlatform.system == "i686-linux" || stdenv.hostPlatform.system == "x86_64-linux")
    ''
      # There are a number of native binaries. We must patch them to let them find the interpreter and libstdc++

      for i in mksdcard
      do
          patchelf --set-interpreter ${stdenv_32bit.cc.libc.out}/lib/ld-linux.so.2 $i
          patchelf --set-rpath ${stdenv_32bit.cc.cc.lib}/lib $i
      done

      ${stdenv.lib.optionalString (stdenv.hostPlatform.system == "x86_64-linux") ''
        for i in bin64/{mkfs.ext4,fsck.ext4,e2fsck,tune2fs,resize2fs}
        do
            patchelf --set-interpreter ${stdenv.cc.libc.out}/lib/ld-linux-x86-64.so.2 $i
            patchelf --set-rpath ${stdenv.cc.cc.lib}/lib64 $i
        done
      ''}

      ${stdenv.lib.optionalString (stdenv.hostPlatform.system == "x86_64-linux") ''
        # We must also patch the 64-bit emulator instances, if needed

        for i in emulator emulator64-arm emulator64-mips emulator64-x86 emulator64-crash-service emulator-check qemu/linux-x86_64/qemu-system-*
        do
            patchelf --set-interpreter ${stdenv.cc.libc.out}/lib/ld-linux-x86-64.so.2 $i
            patchelf --set-rpath ${stdenv.cc.cc.lib}/lib64 $i
        done
      ''}

      # The following scripts used SWT and wants to dynamically load some GTK+ stuff.
      # Creating these wrappers ensure that they can be found:

      wrapProgram `pwd`/android \
        --prefix PATH : ${jdk}/bin \
        --prefix LD_LIBRARY_PATH : ${makeLibraryPath [ glib gtk2 libXtst ]}

      wrapProgram `pwd`/uiautomatorviewer \
        --prefix PATH : ${jdk}/bin \
        --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [ glib gtk2 libXtst ]}

      wrapProgram `pwd`/hierarchyviewer \
        --prefix PATH : ${jdk}/bin \
        --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [ glib gtk2 libXtst ]}

      # The emulators need additional libraries, which are dynamically loaded => let's wrap them

      ${stdenv.lib.optionalString (stdenv.hostPlatform.system == "x86_64-linux") ''
        for i in emulator emulator64-arm emulator64-mips emulator64-x86 emulator64-crash-service
        do
            wrapProgram `pwd`/$i \
              --prefix PATH : ${stdenv.lib.makeBinPath [ file glxinfo ]} \
              --suffix LD_LIBRARY_PATH : `pwd`/lib64:`pwd`/lib64/qt/lib:${makeLibraryPath [ stdenv.cc.cc libX11 libxcb libXau libXdmcp libXext libGLU_combined alsaLib zlib libpulseaudio dbus.lib ]} \
              --suffix QT_XKB_CONFIG_ROOT : ${xkeyboardconfig}/share/X11/xkb
        done
      ''}
    ''}

    patchShebangs .

    ${if stdenv.hostPlatform.system == "i686-linux" then
      ''
        # The monitor requires some more patching

        cd lib/monitor-x86
        patchelf --set-interpreter ${stdenv.cc.libc.out}/lib/ld-linux.so.2 monitor
        patchelf --set-rpath ${makeLibraryPath [ libX11 libXext libXrender freetype fontconfig ]} libcairo-swt.so

        wrapProgram `pwd`/monitor \
          --prefix LD_LIBRARY_PATH : ${makeLibraryPath [ gtk2 atk stdenv.cc.cc libXtst ]}

        cd ../..
      ''
      else if stdenv.hostPlatform.system == "x86_64-linux" then
      ''
        # The monitor requires some more patching

        cd lib/monitor-x86_64
        patchelf --set-interpreter ${stdenv.cc.libc.out}/lib/ld-linux-x86-64.so.2 monitor
        patchelf --set-rpath ${makeLibraryPath [ libX11 libXext libXrender freetype fontconfig ]} libcairo-swt.so

        wrapProgram `pwd`/monitor \
          --prefix LD_LIBRARY_PATH : ${makeLibraryPath [ gtk2 atk stdenv.cc.cc libXtst ]}

        cd ../..
      ''
      else ""}

    # Symlink the other sub packages

    cd ..
    ln -s ${platformTools}/platform-tools
    ln -s ${buildTools}/build-tools
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
          "ln -s ${googleApis}/* addon-google_apis-${platformVersion}\n"
        else "") platformVersions
      else ""}

    cd ..

    # Symlink required extras

    mkdir -p extras/android
    cd extras/android

    ln -s ${supportRepository}/m2repository

    ${if useExtraSupportLibs then
       "ln -s ${addons.android_support_extra}/support ."
     else ""}

    cd ..
    mkdir -p google
    cd google

    ${if useGooglePlayServices then
       "ln -s ${addons.google_play_services}/google-play-services google_play_services"
     else ""}

    ${stdenv.lib.optionalString useInstantApps
       "ln -s ${addons.instant_apps}/whsdk instantapps"}

    ln -s ${googleRepository} m2repository

    cd ../..

    # Symlink required sources
    mkdir -p sources
    cd sources

    ${if includeSources then
        stdenv.lib.concatMapStrings (platformVersion:
        if (builtins.hasAttr ("source_"+platformVersion) sources) then
          let
            source = builtins.getAttr ("source_"+platformVersion) sources;
          in
          "ln -s ${source}/* android-${platformVersion}\n"
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
        "ln -s ${platform}/* android-${platformVersion}\n"
      else ""
    ) platformVersions}

    cd ..

    # Symlink required system images

    mkdir -p system-images
    cd system-images

    ${stdenv.lib.concatMapStrings (abiVersion:
      stdenv.lib.concatMapStrings (platformVersion:
        if (builtins.hasAttr ("sysimg_" + abiVersion + "_" + platformVersion) sysimages) then
          let
            sysimg = builtins.getAttr ("sysimg_" + abiVersion + "_" + platformVersion) sysimages;
          in
          ''
            mkdir -p android-${platformVersion}
            cd android-${platformVersion}
            ln -s ${sysimg}/*
            cd ..
          ''
        else ""
      ) platformVersions
    ) abiVersions}

    # Create wrappers to the most important tools and platform tools so that we can run them if the SDK is in our PATH

    mkdir -p $out/bin

    for i in $out/libexec/tools/*
    do
        if [ ! -d $i ] && [ -x $i ]
        then
            ln -sf $i $out/bin/$(basename $i)
        fi
    done

    for i in $out/libexec/platform-tools/*
    do
        if [ ! -d $i ] && [ -x $i ]
        then
            ln -sf $i $out/bin/$(basename $i)
        fi
    done

    for i in $out/libexec/build-tools/*/*
    do
        if [ ! -d $i ] && [ -x $i ]
        then
            ln -sf $i $out/bin/$(basename $i)
        fi
    done
  '';

  buildInputs = [ unzip makeWrapper ];

  meta = {
    platforms = stdenv.lib.platforms.unix;
    hydraPlatforms = [];
    license = stdenv.lib.licenses.unfree;
  };
}
