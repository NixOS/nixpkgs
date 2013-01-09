{stdenv, xcodewrapper}:
{ name
, src
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
}:

assert release -> codeSignIdentity != null && certificateFile != null && certificatePassword != null && provisioningProfile != null;

let
  # Set some default values here
  
  _target = if target == null then name else target;
  _scheme = if scheme == null then name else scheme;

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
      if release then "iphoneos6.0" else "iphonesimulator6.0"
    else sdk;

  # The following is to prevent repetition
  deleteKeychain = "security delete-keychain $keychainName";
in
stdenv.mkDerivation {
  inherit name src;
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
        PROVISIONING_PROFILE=$(grep UUID -A1 -a ${provisioningProfile} | grep -o "[-A-Z0-9]\{36\}")

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
    xcodebuild -target ${_target} -configuration ${_configuration} -scheme ${_scheme} -sdk ${_sdk} -arch ${_arch} ONLY_ACTIVE_ARCH=NO CONFIGURATION_TEMP_DIR=$TMPDIR CONFIGURATION_BUILD_DIR=$out ${if generateXCArchive then "archive" else ""} ${xcodeFlags} ${if release then ''"CODE_SIGN_IDENTITY=${codeSignIdentity}" PROVISIONING_PROFILE=$PROVISIONING_PROFILE OTHER_CODE_SIGN_FLAGS="--keychain $HOME/Library/Keychains/$keychainName"'' else ""}
    
    ${stdenv.lib.optionalString release ''
      ${stdenv.lib.optionalString generateIPA ''
        # Produce an IPA file
        xcrun -sdk iphoneos PackageApplication -v $out/*.app -o $out/${name}.ipa
      ''}
      
      # Delete our temp keychain
      ${deleteKeychain}
    ''}
  '';
  
  failureHook = stdenv.lib.optionalString release deleteKeychain;
  
  installPhase = "true";
}
