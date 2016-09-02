{stdenv, androidsdk, titaniumsdk, titanium, alloy, xcodewrapper, jdk, python, nodejs, which, xcodeBaseDir}:
{ name, src, target, androidPlatformVersions ? [ "23" ], androidAbiVersions ? [ "armeabi" "armeabi-v7a" ], tiVersion ? null
, release ? false, androidKeyStore ? null, androidKeyAlias ? null, androidKeyStorePassword ? null
, iosMobileProvisioningProfile ? null, iosCertificateName ? null, iosCertificate ? null, iosCertificatePassword ? null, iosVersion ? "9.2"
, enableWirelessDistribution ? false, installURL ? null
}:

assert (release && target == "android") -> androidKeyStore != null && androidKeyAlias != null && androidKeyStorePassword != null;
assert (release && target == "iphone") -> iosMobileProvisioningProfile != null && iosCertificateName != null && iosCertificate != null && iosCertificatePassword != null;
assert enableWirelessDistribution -> installURL != null;

let
  androidsdkComposition = androidsdk {
    platformVersions = androidPlatformVersions;
    abiVersions = androidAbiVersions;
    useGoogleAPIs = true;
  };
  
  deleteKeychain = ''
    security default-keychain -s login.keychain
    security delete-keychain $keychainName
  '';
  
  # On Mac OS X, the java executable shows an -unoffical postfix in the version
  # number. This confuses the build script's version detector.
  # We fix this by creating a wrapper that strips it out of the output.
  
  javaVersionFixWrapper = stdenv.mkDerivation {
    name = "javaVersionFixWrapper";
    buildCommand = ''
      mkdir -p $out/bin
      cat > $out/bin/javac <<EOF
      #! ${stdenv.shell} -e
      
      if [ "\$1" = "-version" ]
      then
          ${jdk}/bin/javac "\$@" 2>&1 | sed "s|-unofficial||" | sed "s|-u60|_60|" >&2
      else
          exec ${jdk}/bin/javac "\$@"
      fi
      EOF
      chmod +x $out/bin/javac
    '';
  };
in
stdenv.mkDerivation {
  name = stdenv.lib.replaceChars [" "] [""] name;
  inherit src;
  
  buildInputs = [ nodejs titanium alloy jdk python which ] ++ stdenv.lib.optional (stdenv.system == "x86_64-darwin") xcodewrapper;
  
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
          ${stdenv.lib.optionalString (stdenv.system == "x86_64-darwin") ''
            # Hack to make version detection work with OpenJDK on Mac OS X
            export PATH=${javaVersionFixWrapper}/bin:$PATH
            export JAVA_HOME=${javaVersionFixWrapper}
            javac -version
          ''}
          
          titanium config --config-file $TMPDIR/config.json --no-colors android.sdk ${androidsdkComposition}/libexec
          
          export PATH=$(echo ${androidsdkComposition}/libexec/tools):$(echo ${androidsdkComposition}/libexec/build-tools/android-*):$PATH
          
          ${if release then
            ''titanium build --config-file $TMPDIR/config.json --no-colors --force --platform android --target dist-playstore --keystore ${androidKeyStore} --alias ${androidKeyAlias} --store-password ${androidKeyStorePassword} --output-dir $out''
          else
            ''titanium build --config-file $TMPDIR/config.json --no-colors --force --platform android --target emulator --build-only -B foo --output $out''}
        ''
      else if target == "iphone" then
        ''
          ${if release then
            ''
              export HOME=/Users/$(whoami)
              export keychainName=$(basename $out)
            
              # Create a keychain with the component hash name (should always be unique)
              security create-keychain -p "" $keychainName
              security default-keychain -s $keychainName
              security unlock-keychain -p "" $keychainName
              security import ${iosCertificate} -k $keychainName -P "${iosCertificatePassword}" -A
              provisioningId=$(grep UUID -A1 -a ${iosMobileProvisioningProfile} | grep -o "[-A-Za-z0-9]\{36\}")
   
              # Ensure that the requested provisioning profile can be found
        
              if [ ! -f "$HOME/Library/MobileDevice/Provisioning Profiles/$provisioningId.mobileprovision" ]
              then
                  mkdir -p "$HOME/Library/MobileDevice/Provisioning Profiles"
                  cp ${iosMobileProvisioningProfile} "$HOME/Library/MobileDevice/Provisioning Profiles/$provisioningId.mobileprovision"
              fi
            
              # Simulate a login
              mkdir -p $HOME/.titanium
              cat > $HOME/.titanium/auth_session.json <<EOF
              { "loggedIn": true }
              EOF
              
              # Configure the path to Xcode
              titanium --config-file $TMPDIR/config.json --no-colors config paths.xcode ${xcodeBaseDir}
              
              # Make plutil available
              mkdir -p $TMPDIR/bin
              ln -s /usr/bin/plutil $TMPDIR/bin
              export PATH=$TMPDIR/bin:$PATH
              
              # Link the modules folder
              if [ ! -e modules ]
              then
                  ln -s ${titaniumsdk}/modules modules
              fi
              
              # Do the actual build
              titanium build --config-file $TMPDIR/config.json --force --no-colors --platform ios --target dist-adhoc --pp-uuid $provisioningId --distribution-name "${iosCertificateName}" --keychain $HOME/Library/Keychains/$keychainName --device-family universal --ios-version ${iosVersion} --output-dir $out
            
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
              
              # We need to consult a real home directory to find the available simulators
              export HOME=/Users/$(whoami)
              
              # Configure the path to Xcode
              titanium --config-file $TMPDIR/config.json --no-colors config paths.xcode ${xcodeBaseDir}
              
              # Link the modules folder
              if [ ! -e modules ]
              then
                  ln -s ${titaniumsdk}/modules modules
                  createdModulesSymlink=1
              fi
              
              # Execute the build
              titanium build --config-file $TMPDIR/config.json --force --no-colors --platform ios --target simulator --build-only --device-family universal --ios-version ${iosVersion} --output-dir $out
              
              # Remove the modules symlink
              if [ "$createdModulesSymlink" = "1" ]
              then
                  rm $out/modules
              fi
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
             echo "file binary-dist \"$(echo $out/Products/Release-iphoneos/*.ipa)\"" > $out/nix-support/hydra-build-products
             
             ${stdenv.lib.optionalString enableWirelessDistribution ''
               appname=$(basename $out/Products/Release-iphoneos/*.ipa .ipa)
               bundleId=$(grep '<id>[a-zA-Z0-9.]*</id>' tiapp.xml | sed -e 's|<id>||' -e 's|</id>||' -e 's/ //g')
               version=$(grep '<version>[a-zA-Z0-9.]*</version>' tiapp.xml | sed -e 's|<version>||' -e 's|</version>||' -e 's/ //g')
               
               sed -e "s|@INSTALL_URL@|${installURL}?bundleId=$bundleId\&amp;version=$version\&amp;title=$appname|" ${../xcodeenv/install.html.template} > "$out/$appname.html"
               echo "doc install \"$out/$appname.html\"" >> $out/nix-support/hydra-build-products
             ''}
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
