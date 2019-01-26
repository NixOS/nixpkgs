{stdenv, composeXcodeWrapper}:
{ name
, src
, sdkVersion ? "11.3"
, target ? null
, configuration ? null
, scheme ? null
, sdk ? null
, xcodeFlags ? ""
, release ? false
, certificateFile ? null
, certificatePassword ? null
, provisioningProfile ? null
, signMethod ? null
, generateIPA ? false
, generateXCArchive ? false
, enableWirelessDistribution ? false
, installURL ? null
, bundleId ? null
, appVersion ? null
, ...
}@args:

assert release -> certificateFile != null && certificatePassword != null && provisioningProfile != null && signMethod != null;
assert enableWirelessDistribution -> installURL != null && bundleId != null && appVersion != null;

let
  # Set some default values here

  _target = if target == null then name else target;

  _configuration = if configuration == null
    then
      if release then "Release" else "Debug"
    else configuration;

  _sdk = if sdk == null
    then
      if release then "iphoneos" + sdkVersion else "iphonesimulator" + sdkVersion
    else sdk;

  # The following is to prevent repetition
  deleteKeychain = ''
    security default-keychain -s login.keychain
    security delete-keychain $keychainName
  '';

  xcodewrapperFormalArgs = builtins.functionArgs composeXcodeWrapper;
  xcodewrapperArgs = builtins.intersectAttrs xcodewrapperFormalArgs args;
  xcodewrapper = composeXcodeWrapper xcodewrapperArgs;

  extraArgs = removeAttrs args ([ "name" "scheme" "xcodeFlags" "release" "certificateFile" "certificatePassword" "provisioningProfile" "signMethod" "generateIPA" "generateXCArchive" "enableWirelessDistribution" "installURL" "bundleId" "version" ] ++ builtins.attrNames xcodewrapperFormalArgs);
in
stdenv.mkDerivation ({
  name = stdenv.lib.replaceChars [" "] [""] name; # iOS app names can contain spaces, but in the Nix store this is not allowed
  buildInputs = [ xcodewrapper ];
  buildPhase = ''
    ${stdenv.lib.optionalString release ''
      export HOME=/Users/$(whoami)
      keychainName="$(basename $out)"

      # Create a keychain
      security create-keychain -p "" $keychainName
      security default-keychain -s $keychainName
      security unlock-keychain -p "" $keychainName

      # Import the certificate into the keychain
      security import ${certificateFile} -k $keychainName -P "${certificatePassword}" -A 

      # Grant the codesign utility permissions to read from the keychain
      security set-key-partition-list -S apple-tool:,apple: -s -k "" $keychainName

      # Determine provisioning ID
      PROVISIONING_PROFILE=$(grep UUID -A1 -a ${provisioningProfile} | grep -o "[-A-Za-z0-9]\{36\}")

      if [ ! -f "$HOME/Library/MobileDevice/Provisioning Profiles/$PROVISIONING_PROFILE.mobileprovision" ]
      then
          # Copy provisioning profile into the home directory
          mkdir -p "$HOME/Library/MobileDevice/Provisioning Profiles"
          cp ${provisioningProfile} "$HOME/Library/MobileDevice/Provisioning Profiles/$PROVISIONING_PROFILE.mobileprovision"
      fi

      # Check whether the identity can be found
      security find-identity -p codesigning $keychainName
    ''}

    # Do the building
    export LD=clang # To avoid problem with -isysroot parameter that is unrecognized by the stock ld. Comparison with an impure build shows that it uses clang instead. Ugly, but it works

    xcodebuild -target ${_target} -configuration ${_configuration} ${stdenv.lib.optionalString (scheme != null) "-scheme ${scheme}"} -sdk ${_sdk} TARGETED_DEVICE_FAMILY="1, 2" ONLY_ACTIVE_ARCH=NO CONFIGURATION_TEMP_DIR=$TMPDIR CONFIGURATION_BUILD_DIR=$out ${if generateIPA || generateXCArchive then "-archivePath \"${name}.xcarchive\" archive" else ""} ${if release then ''PROVISIONING_PROFILE=$PROVISIONING_PROFILE OTHER_CODE_SIGN_FLAGS="--keychain $HOME/Library/Keychains/$keychainName-db"'' else ""} ${xcodeFlags}

    ${stdenv.lib.optionalString release ''
      ${stdenv.lib.optionalString generateIPA ''
        # Create export plist file
        cat > "${name}.plist" <<EOF
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
            <key>provisioningProfiles</key>
            <dict>
                <key>${bundleId}</key>
                <string>$PROVISIONING_PROFILE</string>
            </dict>
            <key>method</key>
            <string>${signMethod}</string>
            ${stdenv.lib.optionalString (signMethod == "enterprise" || signMethod == "ad-hoc") ''
              <key>compileBitcode</key>
              <false/>
            ''}
        </dict>
        </plist>
        EOF

        # Produce an IPA file
        xcodebuild -exportArchive -archivePath "${name}.xcarchive" -exportOptionsPlist "${name}.plist" -exportPath $out

        # Add IPA to Hydra build products
        mkdir -p $out/nix-support
        echo "file binary-dist \"$(echo $out/*.ipa)\"" > $out/nix-support/hydra-build-products

        ${stdenv.lib.optionalString enableWirelessDistribution ''
          # Add another hacky build product that enables wireless adhoc installations
          appname="$(basename "$out/*.ipa" .ipa)"
          sed -e "s|@INSTALL_URL@|${installURL}?bundleId=${bundleId}\&amp;version=${appVersion}\&amp;title=$appname|" ${./install.html.template} > $out/$appname.html
          echo "doc install \"$out/$appname.html\"" >> $out/nix-support/hydra-build-products
        ''}
      ''}
      ${stdenv.lib.optionalString generateXCArchive ''
        mkdir -p $out
        mv "${name}.xcarchive" $out
      ''}

      # Delete our temp keychain
      ${deleteKeychain}
    ''}
  '';

  failureHook = stdenv.lib.optionalString release deleteKeychain;

  installPhase = "true";
} // extraArgs)
