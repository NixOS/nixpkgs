{ composeAndroidPackages, stdenv, lib }:
{ name, app ? null
, platformVersion ? "16", abiVersion ? "armeabi-v7a", systemImageType ? "default"
, enableGPU ? false, extraAVDFiles ? []
, package ? null, activity ? null
, avdHomeDir ? null, sdkExtraArgs ? {}
}:

let
  sdkArgs = {
    platformVersions = [ platformVersion ];
    includeEmulator = true;
    includeSystemImages = true;
    systemImageTypes = [ systemImageType ];
    abiVersions = [ abiVersion ];
  } // sdkExtraArgs;

  sdk = (composeAndroidPackages sdkArgs).androidsdk;
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

    # We need to specify the location of the Android SDK root folder
    export ANDROID_SDK_ROOT=${sdk}/libexec/android-sdk

    # We have to look for a free TCP port

    echo "Looking for a free TCP port in range 5554-5584" >&2

    for i in $(seq 5554 2 5584)
    do
        if [ -z "$(${sdk}/libexec/android-sdk/platform-tools/adb devices | grep emulator-$i)" ]
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
    ${sdk}/libexec/android-sdk/tools/android list targets

    if [ "$(${sdk}/libexec/android-sdk/tools/android list avd | grep 'Name: device')" = "" ]
    then
        # Create a virtual android device
        yes "" | ${sdk}/libexec/android-sdk/tools/android create avd -n device -t 1 --abi ${systemImageType}/${abiVersion} $NIX_ANDROID_AVD_FLAGS

        ${lib.optionalString enableGPU ''
          # Enable GPU acceleration
          echo "hw.gpu.enabled=yes" >> $ANDROID_SDK_HOME/.android/avd/device.avd/config.ini
        ''}

        ${lib.concatMapStrings (extraAVDFile: ''
          ln -sf ${extraAVDFile} $ANDROID_SDK_HOME/.android/avd/device.avd
        '') extraAVDFiles}
    fi

    # Launch the emulator
    ${sdk}/libexec/android-sdk/emulator/emulator -avd device -no-boot-anim -port $port $NIX_ANDROID_EMULATOR_FLAGS &

    # Wait until the device has completely booted
    echo "Waiting until the emulator has booted the device and the package manager is ready..." >&2

    ${sdk}/libexec/android-sdk/platform-tools/adb -s emulator-$port wait-for-device

    echo "Device state has been reached" >&2

    while [ -z "$(${sdk}/libexec/android-sdk/platform-tools/adb -s emulator-$port shell getprop dev.bootcomplete | grep 1)" ]
    do
        sleep 5
    done

    echo "dev.bootcomplete property is 1" >&2

    #while [ -z "$(${sdk}/libexec/android-sdk/platform-tools/adb -s emulator-$port shell getprop sys.boot_completed | grep 1)" ]
    #do
        #sleep 5
    #done

    #echo "sys.boot_completed property is 1" >&2

    echo "ready" >&2

    ${lib.optionalString (app != null) ''
      # Install the App through the debugger, if it has not been installed yet

      if [ -z "${package}" ] || [ "$(${sdk}/libexec/android-sdk/platform-tools/adb -s emulator-$port shell pm list packages | grep package:${package})" = "" ]
      then
          if [ -d "${app}" ]
          then
              appPath="$(echo ${app}/*.apk)"
          else
              appPath="${app}"
          fi

          ${sdk}/libexec/android-sdk/platform-tools/adb -s emulator-$port install "$appPath"
      fi

      # Start the application
      ${lib.optionalString (package != null && activity != null) ''
          ${sdk}/libexec/android-sdk/platform-tools/adb -s emulator-$port shell am start -a android.intent.action.MAIN -n ${package}/${activity}
      ''}
    ''}
    EOF
    chmod +x $out/bin/run-test-emulator
  '';
}
