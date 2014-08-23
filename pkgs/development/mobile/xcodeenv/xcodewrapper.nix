{stdenv, version}:

stdenv.mkDerivation {
  name = "xcode-wrapper-"+version;
  buildCommand = ''
    mkdir -p $out/bin
    cd $out/bin
    ln -s /usr/bin/xcode-select
    ln -s /usr/bin/xcodebuild
    ln -s /usr/bin/xcrun
    ln -s /usr/bin/security
    ln -s /usr/bin/codesign
    ln -s "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Applications/iPhone Simulator.app/Contents/MacOS/iPhone Simulator"

    cd ..
    ln -s "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs"

    # Check if we have the xcodebuild version that we want
    if [ -z "$($out/bin/xcodebuild -version | grep -x 'Xcode ${version}')" ]
    then
        echo "We require xcodebuild version: ${version}"
        exit 1
    fi
  '';
}
