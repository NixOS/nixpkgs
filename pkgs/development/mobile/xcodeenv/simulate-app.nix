{
  stdenv,
  lib,
  composeXcodeWrapper,
}:
{
  name,
  app ? null,
  bundleId ? null,
  ...
}@args:

assert app != null -> bundleId != null;

let
  xcodewrapperArgs = builtins.intersectAttrs (builtins.functionArgs composeXcodeWrapper) args;

  xcodewrapper = composeXcodeWrapper xcodewrapperArgs;
in
stdenv.mkDerivation {
  name = lib.replaceStrings [ " " ] [ "" ] name;
  buildCommand = ''
    mkdir -p $out/bin
    cat > $out/bin/run-test-simulator << "EOF"
    #! ${stdenv.shell} -e

    if [ "$1" = "" ]
    then
        # Show the user the possibile UDIDs and let him pick one, if none is provided as a command-line parameter
        xcrun simctl list

        echo "Please provide a UDID of a simulator:"
        read udid
    else
        # If a parameter has been provided, consider that a device UDID and use that
        udid="$1"
    fi

    # Open the simulator instance
    open -a "$(readlink "${xcodewrapper}/bin/Simulator")" --args -CurrentDeviceUDID $udid

    ${lib.optionalString (app != null) ''
      # Copy the app and restore the write permissions
      appTmpDir=$(mktemp -d -t appTmpDir)
      cp -r "$(echo ${app}/*.app)" "$appTmpDir"
      chmod -R 755 "$(echo $appTmpDir/*.app)"

      # Wait for the simulator to start
      echo "Press enter when the simulator is started..."
      read

      # Install the app
      xcrun simctl install "$udid" "$(echo $appTmpDir/*.app)"

      # Remove the app tempdir
      rm -Rf $appTmpDir

      # Launch the app in the simulator
      xcrun simctl launch $udid "${bundleId}"
      EOF

      chmod +x $out/bin/run-test-simulator
    ''}
  '';
}
