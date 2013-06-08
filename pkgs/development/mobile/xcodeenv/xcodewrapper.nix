{stdenv, version ? "4.6"}:

stdenv.mkDerivation {
  name = "xcode-wrapper-"+version;
  buildCommand = ''
    ensureDir $out/bin
    cd $out/bin
    ln -s /usr/bin/xcode-select
    ln -s /usr/bin/xcodebuild
    ln -s /usr/bin/xcrun
    ln -s /usr/bin/security
    ln -s "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Applications/iPhone Simulator.app/Contents/MacOS/iPhone Simulator"

    # Check if we have the xcodebuild version that we want
    if [ -z "$($out/bin/xcodebuild -version | grep ${version})" ]
    then
        echo "We require xcodebuild version: ${version}"
        exit 1
    fi
  '';
}
