{stdenv, composeAndroidPackages, composeXcodeWrapper, titaniumsdk, titanium, alloy, jdk, python, nodejs, which, file}:
{ name, src, preBuild ? "", target, tiVersion ? null
, release ? false, androidKeyStore ? null, androidKeyAlias ? null, androidKeyStorePassword ? null
, iosMobileProvisioningProfile ? null, iosCertificateName ? null, iosCertificate ? null, iosCertificatePassword ? null, iosVersion ? "12.1", iosBuildStore ? false
, enableWirelessDistribution ? false, installURL ? null
, xcodeBaseDir ? "/Applications/Xcode.app"
, androidsdkArgs ? {}
, xcodewrapperArgs ? {}
, ...
}@args:

assert (release && target == "android") -> androidKeyStore != null && androidKeyAlias != null && androidKeyStorePassword != null;
assert (release && target == "iphone") -> iosMobileProvisioningProfile != null && iosCertificateName != null && iosCertificate != null && iosCertificatePassword != null;
assert enableWirelessDistribution -> installURL != null;

let
  realAndroidsdkArgs = {
    platformVersions = [ "28" ];
  } // androidsdkArgs;

  androidsdk = (composeAndroidPackages realAndroidsdkArgs).androidsdk;

  realXcodewrapperArgs = {
    inherit xcodeBaseDir;
  } // xcodewrapperArgs;

  xcodewrapper = composeXcodeWrapper xcodewrapperArgs;

  deleteKeychain = ''
    if [ -f $HOME/lock-keychain ]
    then
        security default-keychain -s login.keychain
        security delete-keychain $keychainName
        rm -f $HOME/lock-keychain
    fi
  '';

  extraArgs = removeAttrs args [ "name" "preRebuild" "androidsdkArgs" "xcodewrapperArgs" ];
in
stdenv.mkDerivation ({
  name = stdenv.lib.replaceChars [" "] [""] name;

  buildInputs = [ nodejs titanium alloy python which file jdk ]
    ++ stdenv.lib.optional (target == "iphone") xcodewrapper;

  buildPhase = ''
    ${preBuild}

    ${stdenv.lib.optionalString stdenv.isDarwin ''
      # Hack that provides a writable alloy package on macOS. Without it the build fails because of a file permission error.
      alloy=$(dirname $(type -p alloy))/..
      cp -rv $alloy/* alloy
      chmod -R u+w alloy
      export PATH=$(pwd)/alloy/bin:$PATH
    ''}

    export HOME=${if target == "iphone" then "/Users/$(whoami)" else "$TMPDIR"}

    ${stdenv.lib.optionalString (tiVersion != null) ''
      # Replace titanium version by the provided one
      sed -i -e "s|<sdk-version>[0-9a-zA-Z\.]*</sdk-version>|<sdk-version>${tiVersion}</sdk-version>|" tiapp.xml
    ''}

    # Simulate a login
    mkdir -p $HOME/.titanium
    cat > $HOME/.titanium/auth_session.json <<EOF
    { "loggedIn": true }
    EOF

    # Configure the paths to the Titanium SDK and modules
    echo "{}" > $TMPDIR/config.json
    titanium --config-file $TMPDIR/config.json --no-colors config sdk.defaultInstallLocation ${titaniumsdk}
    titanium --config-file $TMPDIR/config.json --no-colors config paths.modules ${titaniumsdk}

    mkdir -p $out

    ${if target == "android" then ''
      titanium config --config-file $TMPDIR/config.json --no-colors android.sdkPath ${androidsdk}/libexec/android-sdk

      export PATH=${androidsdk}/libexec/android-sdk/tools:$(echo ${androidsdk}/libexec/android-sdk/build-tools/android-*):$PATH
      export GRADLE_USER_HOME=$TMPDIR/gradle

      ${if release then ''
        ${stdenv.lib.optionalString stdenv.isDarwin ''
          # Signing the app does not work with OpenJDK on macOS, use host SDK instead
          export JAVA_HOME="$(/usr/libexec/java_home -v 1.8)"
        ''}
        titanium build --config-file $TMPDIR/config.json --no-colors --force --platform android --target dist-playstore --keystore ${androidKeyStore} --alias "${androidKeyAlias}" --store-password "${androidKeyStorePassword}" --output-dir $out
      '' else ''
        titanium build --config-file $TMPDIR/config.json --no-colors --force --platform android --target emulator --build-only -B foo --output $out
      ''}
    ''
    else if target == "iphone" then ''
      # Configure the path to Xcode
      titanium --config-file $TMPDIR/config.json --no-colors config paths.xcode ${xcodeBaseDir}

      # Link the modules folder
      if [ ! -e modules ]
      then
          ln -s ${titaniumsdk}/modules modules
          createdModulesSymlink=1
      fi

      ${if release then ''
        # Create a keychain with the component hash name (should always be unique)
        export keychainName=$(basename $out)

        security create-keychain -p "" $keychainName
        security default-keychain -s $keychainName
        security unlock-keychain -p "" $keychainName
        security import ${iosCertificate} -k $keychainName -P "${iosCertificatePassword}" -A
        security set-key-partition-list -S apple-tool:,apple: -s -k "" $keychainName
        provisioningId=$(grep UUID -A1 -a ${iosMobileProvisioningProfile} | grep -o "[-A-Za-z0-9]\{36\}")

        # Ensure that the requested provisioning profile can be found

        if [ ! -f "$HOME/Library/MobileDevice/Provisioning Profiles/$provisioningId.mobileprovision" ]
        then
            mkdir -p "$HOME/Library/MobileDevice/Provisioning Profiles"
            cp ${iosMobileProvisioningProfile} "$HOME/Library/MobileDevice/Provisioning Profiles/$provisioningId.mobileprovision"
        fi

        # Take precautions to prevent concurrent builds blocking the keychain
        while [ -f $HOME/lock-keychain ]
        do
            echo "Keychain locked, waiting for a couple of seconds, or remove $HOME/lock-keychain to unblock..."
            sleep 3
        done

        touch $HOME/lock-keychain

        security default-keychain -s $keychainName

        # Do the actual build
        titanium build --config-file $TMPDIR/config.json --force --no-colors --platform ios --target ${if iosBuildStore then "dist-appstore" else "dist-adhoc"} --pp-uuid $provisioningId --distribution-name "${iosCertificateName}" --keychain $HOME/Library/Keychains/$keychainName-db --device-family universal --ios-version ${iosVersion} --output-dir $out

        # Remove our generated keychain
        ${deleteKeychain}
      '' else ''
        # Copy all sources to the output store directory.
        # Why? Debug application include *.js files, which are symlinked into their
        # sources. If they are not copied, we have dangling references to the
        # temp folder.

        cp -av * $out
        cd $out

        # Execute the build
        titanium build --config-file $TMPDIR/config.json --force --no-colors --platform ios --target simulator --build-only --device-family universal --ios-version ${iosVersion} --output-dir $out

        # Remove the modules symlink
        if [ "$createdModulesSymlink" = "1" ]
        then
            rm $out/modules
        fi
      ''}
    '' else throw "Target: ${target} is not supported!"}
  '';

  installPhase = ''
    ${if target == "android" then ''
      ${if release then ""
      else ''
        cp "$(ls build/android/bin/*.apk | grep -v '\-unsigned.apk')" $out
      ''}

      mkdir -p $out/nix-support
      echo "file binary-dist \"$(ls $out/*.apk)\"" > $out/nix-support/hydra-build-products
    ''
    else if target == "iphone" then
      if release then ''
        mkdir -p $out/nix-support
        echo "file binary-dist \"$(echo $out/*.ipa)\"" > $out/nix-support/hydra-build-products

        ${stdenv.lib.optionalString enableWirelessDistribution ''
          appname="$(basename "$out/*.ipa" .ipa)"
          bundleId=$(grep '<id>[a-zA-Z0-9.]*</id>' tiapp.xml | sed -e 's|<id>||' -e 's|</id>||' -e 's/ //g')
          version=$(grep '<version>[a-zA-Z0-9.]*</version>' tiapp.xml | sed -e 's|<version>||' -e 's|</version>||' -e 's/ //g')

          sed -e "s|@INSTALL_URL@|${installURL}?bundleId=$bundleId\&amp;version=$version\&amp;title=$appname|" ${../xcodeenv/install.html.template} > "$out/$appname.html"
          echo "doc install \"$out/$appname.html\"" >> $out/nix-support/hydra-build-products
        ''}
      ''
      else ""
    else throw "Target: ${target} is not supported!"}
  '';

  failureHook = stdenv.lib.optionalString (release && target == "iphone") deleteKeychain;
} // extraArgs)
