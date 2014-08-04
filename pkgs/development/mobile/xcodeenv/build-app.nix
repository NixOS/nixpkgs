{stdenv, xcodewrapper}:
{ name
, src
, sdkVersion ? "6.1"
, target ? null
, configuration ? null
, scheme ? null
, sdk ? null
, arch ? null
, xcodeFlags ? ""
, release ? false
, codeSignIdentity ? null
, certificateFile ? null
, certificatePassword ? null
, provisioningProfile ? null
, generateIPA ? false
, generateXCArchive ? false
, enableWirelessDistribution ? false
, installURL ? null
, bundleId ? null
, version ? null
, title ? null
}:

assert release -> codeSignIdentity != null && certificateFile != null && certificatePassword != null && provisioningProfile != null;
assert enableWirelessDistribution -> installURL != null && bundleId != null && version != null && title != null;

let
  # Set some default values here
  
  _target = if target == null then name else target;

  _configuration = if configuration == null
    then
      if release then "Release" else "Debug"
    else configuration;
    
  _arch = if arch == null
    then
      if release then "armv7" else "i386"
    else arch;

  _sdk = if sdk == null
    then
      if release then "iphoneos" + sdkVersion else "iphonesimulator" + sdkVersion
    else sdk;

  # The following is to prevent repetition
  deleteKeychain = "security delete-keychain $keychainName";
in
stdenv.mkDerivation {
  name = stdenv.lib.replaceChars [" "] [""] name;
  inherit src;
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
    xcodebuild -target ${_target} -configuration ${_configuration} ${stdenv.lib.optionalString (scheme != null) "-scheme ${scheme}"} -sdk ${_sdk} -arch ${_arch} ONLY_ACTIVE_ARCH=NO CONFIGURATION_TEMP_DIR=$TMPDIR CONFIGURATION_BUILD_DIR=$out ${if generateXCArchive then "archive" else ""} ${xcodeFlags} ${if release then ''"CODE_SIGN_IDENTITY=${codeSignIdentity}" PROVISIONING_PROFILE=$PROVISIONING_PROFILE OTHER_CODE_SIGN_FLAGS="--keychain $HOME/Library/Keychains/$keychainName"'' else ""}
    
    ${stdenv.lib.optionalString release ''
      ${stdenv.lib.optionalString generateIPA ''
        # Produce an IPA file
        xcrun -sdk iphoneos PackageApplication -v $out/*.app -o "$out/${name}.ipa"
        
        # Add IPA to Hydra build products
        mkdir -p $out/nix-support
        echo "file binary-dist \"$(echo $out/*.ipa)\"" > $out/nix-support/hydra-build-products
        
        ${stdenv.lib.optionalString enableWirelessDistribution ''
          appname=$(basename $out/*.ipa .ipa)
          sed -e "s|@INSTALL_URL@|${installURL}?bundleId=${bundleId}\&amp;version=${version}\&amp;title=$appname|" ${./install.html.template} > $out/$appname.html
          echo "doc install $out/$appname.html" >> $out/nix-support/hydra-build-products
        ''}
      ''}
      
      # Delete our temp keychain
      ${deleteKeychain}
    ''}
  '';
  
  failureHook = stdenv.lib.optionalString release deleteKeychain;
  
  installPhase = "true";
}
