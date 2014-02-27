{stdenv, androidsdk}:
{ name, app ? null
, platformVersion ? "8", abiVersion ? "armeabi-v7a", useGoogleAPIs ? false
, enableGPU ? false, extraAVDFiles ? []
, package ? null, activity ? null
, avdHomeDir ? null
}:

let
  androidsdkComposition = androidsdk {
    inherit useGoogleAPIs;
    platformVersions = [ platformVersion ];
    abiVersions = [ abiVersion ];
  };
in
stdenv.mkDerivation {
  inherit name;
  
  buildCommand = ''
    mkdir -p $out/bin
    
    cat > $out/bin/run-test-emulator << "EOF"
    #! ${stdenv.shell} -e
    
    # We need a TMPDIR
    if [ "$TMPDIR" = "" ]
    then
        export TMPDIR=/tmp
    fi
    
    ${if avdHomeDir == null then ''
      # Store the virtual devices somewhere else, instead of polluting a user's HOME directory
      export ANDROID_SDK_HOME=$(mktemp -d $TMPDIR/nix-android-vm-XXXX)
    '' else ''
      mkdir -p "${avdHomeDir}"
      export ANDROID_SDK_HOME="${avdHomeDir}"
    ''}
    
    # We have to look for a free TCP port
    
    echo "Looking for a free TCP port in range 5554-5584" >&2
    
    for i in $(seq 5554 2 5584)
    do
        if [ -z "$(${androidsdkComposition}/libexec/android-sdk-*/platform-tools/adb devices | grep emulator-$i)" ]
        then
            port=$i
            break
        fi
    done
    
    if [ -z "$port" ]
    then
        echo "Unfortunately, the emulator port space is exhausted!" >&2
        exit 1
    else
        echo "We have a free TCP port: $port" >&2
    fi
    
    export ANDROID_SERIAL="emulator-$port"
    
    # Create a virtual android device for testing if it does not exists
    
    if [ "$(android list avd | grep 'Name: device')" = "" ]
    then
        # Create a virtual android device
        yes "" | ${androidsdkComposition}/libexec/android-sdk-*/tools/android create avd -n device -t ${if useGoogleAPIs then "'Google Inc.:Google APIs:"+platformVersion+"'" else "android-"+platformVersion} $NIX_ANDROID_AVD_FLAGS
    
        ${stdenv.lib.optionalString enableGPU ''
          # Enable GPU acceleration
          echo "hw.gpu.enabled=yes" >> $ANDROID_SDK_HOME/.android/avd/device.avd/config.ini
        ''}
    
        ${stdenv.lib.concatMapStrings (extraAVDFile: ''
          ln -sf ${extraAVDFile} $ANDROID_SDK_HOME/.android/avd/device.avd
        '') extraAVDFiles}
    fi
    
    # Launch the emulator
    ${androidsdkComposition}/libexec/android-sdk-*/tools/emulator -avd device -no-boot-anim -port $port $NIX_ANDROID_EMULATOR_FLAGS &

    # Wait until the device has completely booted
    
    echo "Waiting until the emulator has booted the device and the package manager is ready..." >&2
    
    ${androidsdkComposition}/libexec/android-sdk-*/platform-tools/adb -s emulator-$port wait-for-device
    
    echo "Device state has been reached" >&2
    
    while [ -z "$(${androidsdkComposition}/libexec/android-sdk-*/platform-tools/adb -s emulator-$port shell getprop dev.bootcomplete | grep 1)" ]
    do
        sleep 5
    done
    
    echo "dev.bootcomplete property is 1" >&2
    
    #while [ -z "$(${androidsdkComposition}/libexec/android-sdk-*/platform-tools/adb -s emulator-$port shell getprop sys.boot_completed | grep 1)" ]
    #do
        #sleep 5
    #done
    
    #echo "sys.boot_completed property is 1" >&2
    
    echo "ready" >&2
    
    ${stdenv.lib.optionalString (app != null) ''
      # Install the App through the debugger, if it has not been installed yet
      
      if [ -z "${package}" ] || [ "$(adb -s emulator-$port shell pm list packages | grep package:${package})" = "" ]
      then
          if [ -d "${app}" ]
          then
              appPath="$(echo ${app}/*.apk)"
          else
              appPath="${app}"
          fi
          
          ${androidsdkComposition}/libexec/android-sdk-*/platform-tools/adb -s emulator-$port install "$appPath"
      fi
    
      # Start the application
      ${stdenv.lib.optionalString (package != null && activity != null) ''
          ${androidsdkComposition}/libexec/android-sdk-*/platform-tools/adb -s emulator-$port shell am start -a android.intent.action.MAIN -n ${package}/${activity}
      ''}
    ''}
    EOF
    chmod +x $out/bin/run-test-emulator
  '';
}
