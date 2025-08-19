{
  composeAndroidPackages,
  stdenv,
  lib,
  runtimeShell,
  meta,
}:
{
  name,
  app ? null,
  platformVersion ? "35",
  abiVersion ? "x86",
  systemImageType ? "default",
  enableGPU ? false, # Enable GPU acceleration. It's deprecated, instead use `configOptions` below.
  configOptions ? (
    # List of options to add in config.ini
    lib.optionalAttrs enableGPU (
      lib.warn "enableGPU argument is deprecated and will be removed; use configOptions instead" {
        "hw.gpu.enabled" = "yes";
      }
    )
  ),
  extraAVDFiles ? [ ],
  package ? null,
  activity ? null,
  androidUserHome ? null,
  avdHomeDir ? null, # Support old variable with non-standard naming!
  androidAvdHome ? avdHomeDir,
  deviceName ? "device",
  sdkExtraArgs ? { },
  androidAvdFlags ? null,
  androidEmulatorFlags ? null,
}:

let
  sdkArgs = {
    includeEmulator = true;
    includeSystemImages = true;
  }
  // sdkExtraArgs
  // {
    cmdLineToolsVersion = "8.0";
    platformVersions = [ platformVersion ];
    systemImageTypes = [ systemImageType ];
    abiVersions = [ abiVersion ];
  };

  sdk = (composeAndroidPackages sdkArgs).androidsdk;
in
stdenv.mkDerivation {
  inherit name;

  buildCommand = ''
    mkdir -p $out/bin

    cat > $out/bin/run-test-emulator << "EOF"
    #!${runtimeShell} -e

    # We need a TMPDIR
    if [ "$TMPDIR" = "" ]
    then
        export TMPDIR=/tmp
    fi

    ${
      if androidUserHome == null then
        ''
          # Store the virtual devices somewhere else, instead of polluting a user's HOME directory
          export ANDROID_USER_HOME=$(mktemp -d $TMPDIR/nix-android-user-home-XXXX)
        ''
      else
        ''
          mkdir -p "${androidUserHome}"
          export ANDROID_USER_HOME="${androidUserHome}"
        ''
    }

    ${
      if androidAvdHome == null then
        ''
          export ANDROID_AVD_HOME=$ANDROID_USER_HOME/avd
        ''
      else
        ''
          mkdir -p "${androidAvdHome}"
          export ANDROID_AVD_HOME="${androidAvdHome}"
        ''
    }

    # We need to specify the location of the Android SDK root folder
    export ANDROID_SDK_ROOT=${sdk}/libexec/android-sdk

    ${lib.optionalString (androidAvdFlags != null) ''
      # If NIX_ANDROID_AVD_FLAGS is empty
      if [[ -z "$NIX_ANDROID_AVD_FLAGS" ]]; then
        NIX_ANDROID_AVD_FLAGS="${androidAvdFlags}"
      fi
    ''}

    ${lib.optionalString (androidEmulatorFlags != null) ''
      # If NIX_ANDROID_EMULATOR_FLAGS is empty
      if [[ -z "$NIX_ANDROID_EMULATOR_FLAGS" ]]; then
        NIX_ANDROID_EMULATOR_FLAGS="${androidEmulatorFlags}"
      fi
    ''}

    # We have to look for a free TCP port

    echo "Looking for a free TCP port in range 5554-5584" >&2

    for i in $(seq 5554 2 5584)
    do
        if [ -z "$(${sdk}/bin/adb devices | grep emulator-$i)" ]
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

    # Create a virtual android device for testing if it does not exist
    if [ "$(${sdk}/bin/avdmanager list avd | grep 'Name: ${deviceName}')" = "" ]
    then
        # Create a virtual android device
        yes "" | ${sdk}/bin/avdmanager create avd --force -n ${deviceName} -k "system-images;android-${platformVersion};${systemImageType};${abiVersion}" -p $ANDROID_AVD_HOME/${deviceName}.avd $NIX_ANDROID_AVD_FLAGS

        ${builtins.concatStringsSep "\n" (
          lib.mapAttrsToList (configKey: configValue: ''
            echo "${configKey} = ${configValue}" >> $ANDROID_AVD_HOME/${deviceName}.avd/config.ini
          '') configOptions
        )}

        ${lib.concatMapStrings (extraAVDFile: ''
          ln -sf ${extraAVDFile} $ANDROID_AVD_HOME/${deviceName}.avd
        '') extraAVDFiles}
    fi

    # Launch the emulator
    echo "\nLaunch the emulator"
    $ANDROID_SDK_ROOT/emulator/emulator -avd ${deviceName} -no-boot-anim -port $port $NIX_ANDROID_EMULATOR_FLAGS &

    # Wait until the device has completely booted
    echo "Waiting until the emulator has booted the ${deviceName} and the package manager is ready..." >&2

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

  meta = meta // {
    mainProgram = "run-test-emulator";
  };
}
