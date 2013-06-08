{stdenv, androidsdk}:
{name, app, platformVersion ? "8", useGoogleAPIs ? false, package, activity}:

let
  androidsdkComposition = androidsdk { inherit useGoogleAPIs; platformVersions = [ platformVersion ]; };
in
stdenv.mkDerivation {
  inherit name;
  
  buildCommand = ''
    mkdir -p $out/bin
    
    cat > $out/bin/run-test-emulator << "EOF"
    #!/bin/sh -e
    
    # We need a TMPDIR
    if [ "$TMPDIR" = "" ]
    then
        export TMPDIR=/tmp
    fi
    
    # Store the virtual devices somewhere else, instead of polluting a user's HOME directory
    export ANDROID_SDK_HOME=$(mktemp -d $TMPDIR/nix-android-vm-XXXX)
    
    # We have to look for a free TCP port
    
    echo "Looking for a free TCP port in range 5554-5584"
    
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
        echo "Unfortunately, the emulator port space is exhausted!"
        exit 1
    else
        echo "We have a free TCP port: $port"
    fi
    
    export ANDROID_SERIAL="emulator-$port"
    
    # Create a virtual android device
    ${androidsdkComposition}/libexec/android-sdk-*/tools/android create avd -n device -t ${if useGoogleAPIs then "'Google Inc.:Google APIs:"+platformVersion+"'" else "android-"+platformVersion}
    
    # Launch the emulator
    ${androidsdkComposition}/libexec/android-sdk-*/tools/emulator -avd device -no-boot-anim -port $port &

    # Wait until the device has completely booted
    
    echo "Waiting until the emulator has booted the device and the package manager is ready..."
    
    ${androidsdkComposition}/libexec/android-sdk-*/platform-tools/adb -s emulator-$port wait-for-device
    
    echo "Device state has been reached"
    
    while [ -z "$(${androidsdkComposition}/libexec/android-sdk-*/platform-tools/adb -s emulator-$port shell getprop dev.bootcomplete | grep 1)" ]
    do
        sleep 5
    done
    
    echo "dev.bootcomplete property is 1"
    
    #while [ -z "$(${androidsdkComposition}/libexec/android-sdk-*/platform-tools/adb -s emulator-$port shell getprop sys.boot_completed | grep 1)" ]
    #do
        #sleep 5
    #done
    
    #echo "sys.boot_completed property is 1"
    
    echo "ready"
    
    # Install the App through the debugger
    ${androidsdkComposition}/libexec/android-sdk-*/platform-tools/adb -s emulator-$port install ${app}/*.apk
    
    # Start the application
    ${androidsdkComposition}/libexec/android-sdk-*/platform-tools/adb -s emulator-$port shell am start -a android.intent.action.MAIN -n ${package}/.${activity}
    EOF
    
    chmod +x $out/bin/run-test-emulator
  '';
}
