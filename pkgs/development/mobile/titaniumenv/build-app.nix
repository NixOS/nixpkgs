{stdenv, androidsdk, titaniumsdk, titanium, xcodewrapper, jdk, python, which}:
{ name, src, target, androidPlatformVersions ? [ "8" ], androidAbiVersions ? [ "armeabi" "armeabi-v7a" ], tiVersion ? null
, release ? false, androidKeyStore ? null, androidKeyAlias ? null, androidKeyStorePassword ? null
, iosMobileProvisioningProfile ? null, iosCertificateName ? null, iosCertificate ? null, iosCertificatePassword ? null
}:

assert (release && target == "android") -> androidKeyStore != null && androidKeyAlias != null && androidKeyStorePassword != null;
assert (release && target == "iphone") -> iosMobileProvisioningProfile != null && iosCertificateName != null && iosCertificate != null && iosCertificatePassword != null;

let
  androidsdkComposition = androidsdk {
    platformVersions = androidPlatformVersions;
    abiVersions = androidAbiVersions;
    useGoogleAPIs = true;
  };
  
  deleteKeychain = "security delete-keychain $keychainName";
in
stdenv.mkDerivation {
  name = stdenv.lib.replaceChars [" "] [""] name;
  inherit src;
  
  buildInputs = [ titanium jdk python which ] ++ stdenv.lib.optional (stdenv.system == "x86_64-darwin") xcodewrapper;
  
  buildPhase = ''
    export HOME=$TMPDIR
    
    ${stdenv.lib.optionalString (tiVersion != null) ''
      # Replace titanium version by the provided one
      sed -i -e "s|<sdk-version>[0-9a-zA-Z\.]*</sdk-version>|<sdk-version>${tiVersion}</sdk-version>|" tiapp.xml
    ''}
    
    # Simulate a login
    mkdir -p $HOME/.titanium
    cat > $HOME/.titanium/auth_session.json <<EOF
    { "loggedIn": true }
    EOF
    
    echo "{}" > $TMPDIR/config.json
    titanium --config-file $TMPDIR/config.json --no-colors config sdk.defaultInstallLocation ${titaniumsdk}
    
    titanium --config-file $TMPDIR/config.json --no-colors config paths.modules ${titaniumsdk}
    
    mkdir -p $out
    
    ${if target == "android" then
        ''
          titanium config --config-file $TMPDIR/config.json --no-colors android.sdkPath ${androidsdkComposition}/libexec/android-sdk-*
          
          ${if release then
            ''titanium build --config-file $TMPDIR/config.json --no-colors --force --platform android --target dist-playstore --keystore ${androidKeyStore} --alias ${androidKeyAlias} --password ${androidKeyStorePassword} --output-dir $out''
          else
            ''titanium build --config-file $TMPDIR/config.json --no-colors --force --platform android --target emulator --build-only --output $out''}
        ''
      else if target == "iphone" then
        ''
          export NIX_TITANIUM_WORKAROUND="--config-file $TMPDIR/config.json"
          
          ${if release then
            ''
              export HOME=/Users/$(whoami)
              export keychainName=$(basename $out)
            
              # Create a keychain with the component hash name (should always be unique)
              security create-keychain -p "" $keychainName
              security default-keychain -s $keychainName
              security unlock-keychain -p "" $keychainName
              security import ${iosCertificate} -k $keychainName -P "${iosCertificatePassword}" -A

              provisioningId=$(grep UUID -A1 -a ${iosMobileProvisioningProfile} | grep -o "[-A-Z0-9]\{36\}")
   
              # Ensure that the requested provisioning profile can be found
        
              if [ ! -f "$HOME/Library/MobileDevice/Provisioning Profiles/$provisioningId.mobileprovision" ]
              then
                  mkdir -p "$HOME/Library/MobileDevice/Provisioning Profiles"
                  cp ${iosMobileProvisioningProfile} "$HOME/Library/MobileDevice/Provisioning Profiles/$provisioningId.mobileprovision"
              fi
            
              # Make a copy of the Titanium SDK and fix its permissions. Without it,
              # builds using the facebook module fail, because it needs to be writable
            
              cp -av ${titaniumsdk} $TMPDIR/titaniumsdk
            
              find $TMPDIR/titaniumsdk | while read i
              do
                  chmod 755 "$i"
              done
              
              # Simulate a login
              mkdir -p $HOME/.titanium
              cat > $HOME/.titanium/auth_session.json <<EOF
              { "loggedIn": true }
              EOF
            
              # Set the SDK to our copy
              titanium --config-file $TMPDIR/config.json --no-colors config sdk.defaultInstallLocation $TMPDIR/titaniumsdk
            
              # Do the actual build
              titanium build --config-file $TMPDIR/config.json --force --no-colors --platform ios --target dist-adhoc --pp-uuid $provisioningId --distribution-name "${iosCertificateName}" --keychain $HOME/Library/Keychains/$keychainName --device-family universal --output-dir $out
            
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
            
              titanium build --config-file $TMPDIR/config.json --force --no-colors --platform ios --target simulator --build-only --device-family universal --output-dir $out
          ''}
        ''

      else throw "Target: ${target} is not supported!"}
  '';
  
  installPhase = ''
    mkdir -p $out
    
    ${if target == "android" && release then ""
      else
        if target == "android" then
          ''cp "$(ls build/android/bin/*.apk | grep -v '\-unsigned.apk')" $out''
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
