{stdenv, androidsdk, titaniumsdk, xcodewrapper}:
{ appId, name, appName ? null, src, target, androidPlatformVersions ? [ "8" ], androidAbiVersions ? [ "armeabi" "armeabi-v7a" ]
, release ? false, androidKeyStore ? null, androidKeyAlias ? null, androidKeyStorePassword ? null
, iosKeyFile ? null, iosCertificateName ? null, iosCertificate ? null, iosCertificatePassword ? null, iosDistribute ? false
}:

assert (release && target == "android") -> androidKeyStore != null && androidKeyAlias != null && androidKeyStorePassword != null;
assert (release && target == "iphone") -> iosKeyFile != null && iosCertificateName != null && iosCertificate != null && iosCertificatePassword != null;

let
  androidsdkComposition = androidsdk {
    platformVersions = androidPlatformVersions;
    abiVersions = androidAbiVersions;
    useGoogleAPIs = true;
  };
  
  deleteKeychain = "security delete-keychain $keychainName";
  
  _appName = if appName == null then name else appName;
in
stdenv.mkDerivation {
  name = stdenv.lib.replaceChars [" "] [""] name;
  inherit src;
  
  buildInputs = [] ++ stdenv.lib.optional (stdenv.system == "x86_64-darwin") xcodewrapper;

  buildPhase = ''
    export HOME=$TMPDIR

    mkdir -p $out
    
    ${if target == "android" then
        if release then
          ''${titaniumsdk}/mobilesdk/*/*/android/builder.py distribute "${_appName}" ${androidsdkComposition}/libexec/android-sdk-* $(pwd) ${appId} ${androidKeyStore} ${androidKeyStorePassword} ${androidKeyAlias} $out''
        else
          ''${titaniumsdk}/mobilesdk/*/*/android/builder.py build "${_appName}" ${androidsdkComposition}/libexec/android-sdk-* $(pwd) ${appId}''

      else if target == "iphone" then
        if iosDistribute then ''
            export HOME=/Users/$(whoami)
            export keychainName=$(basename $out)
            
            # Create a keychain with the component hash name (should always be unique)
            security create-keychain -p "" $keychainName
            security default-keychain -s $keychainName
            security unlock-keychain -p "" $keychainName
            security import ${iosCertificate} -k $keychainName -P "${iosCertificatePassword}" -A

            provisioningId=$(grep UUID -A1 -a ${iosKeyFile} | grep -o "[-A-Z0-9]\{36\}")
   
            # Ensure that the requested provisioning profile can be found
            
            if [ ! -f "$HOME/Library/MobileDevice/Provisioning Profiles/$provisioningId.mobileprovision" ]
            then
                mkdir -p "$HOME/Library/MobileDevice/Provisioning Profiles"
                cp ${iosKeyFile} "$HOME/Library/MobileDevice/Provisioning Profiles/$provisioningId.mobileprovision"
            fi
            
            ${titaniumsdk}/mobilesdk/*/*/iphone/builder.py distribute 6.0 $(pwd) ${appId} "${_appName}" "$provisioningId" "${iosCertificateName}" $out universal "$HOME/Library/Keychains/$keychainName"
            
            # Remove our generated keychain
            
            ${deleteKeychain}
          ''
        else
            if release then
              ''
                export HOME=/Users/$(whoami)
                export keychainName=$(basename $out)
            
                # Create a keychain with the component hash name (should always be unique)
                security create-keychain -p "" $keychainName
                security default-keychain -s $keychainName
                security unlock-keychain -p "" $keychainName
                security import ${iosCertificate} -k $keychainName -P "${iosCertificatePassword}" -A

                provisioningId=$(grep UUID -A1 -a ${iosKeyFile} | grep -o "[-A-Z0-9]\{36\}")
   
                # Ensure that the requested provisioning profile can be found
            
                if [ ! -f "$HOME/Library/MobileDevice/Provisioning Profiles/$provisioningId.mobileprovision" ]
                then
                    mkdir -p "$HOME/Library/MobileDevice/Provisioning Profiles"
                    cp ${iosKeyFile} "$HOME/Library/MobileDevice/Provisioning Profiles/$provisioningId.mobileprovision"
                fi
            
                ${titaniumsdk}/mobilesdk/*/*/iphone/builder.py adhoc 6.0 $(pwd) ${appId} "${_appName}" "$provisioningId" "${iosCertificateName}" universal "$HOME/Library/Keychains/$keychainName"
            
                # Remove our generated keychain
            
                ${deleteKeychain}
          ''
        else
          ''
            # Copy all sources to the output store directory.
            # Why? Debug application include *.js files, which are symlinked into their
            # sources. If they are not copied, we have dangling references to the
            # temp folder.
            
            cp -av * $out
            cd $out
            ${titaniumsdk}/mobilesdk/*/*/iphone/builder.py build 6.0 $(pwd) ${appId} "${_appName}" universal
          ''

      else throw "Target: ${target} is not supported!"}
  '';
  
  installPhase = ''
    mkdir -p $out
    
    ${if target == "android" && release then ""
      else
        if target == "android" then
          ''cp $(ls build/android/bin/*.apk | grep -v '\-unsigned.apk') $out''
        else if target == "iphone" && release then
           ''
             cp -av build/iphone/build/* $out
             mkdir -p $out/nix-support
             echo "file binary-dist \"$(echo $out/Release-iphoneos/*.ipa)\"" > $out/nix-support/hydra-build-products
           ''
        else if target == "iphone" then ""
        else throw "Target: ${target} is not supported!"}
    
    ${if target == "android" then ''
        mkdir -p $out/nix-support
        echo "file binary-dist \"$(ls $out/*.apk)\"" > $out/nix-support/hydra-build-products
    '' else ""}
  '';
  
  failureHook = stdenv.lib.optionalString (release && target == "iphone") deleteKeychain;
}
