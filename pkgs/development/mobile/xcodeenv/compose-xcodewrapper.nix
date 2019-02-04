{stdenv}:
{version ? "10.1", xcodeBaseDir ? "/Applications/Xcode.app"}:

assert stdenv.isDarwin;

stdenv.mkDerivation {
  name = "xcode-wrapper-"+version;
  buildCommand = ''
    mkdir -p $out/bin
    cd $out/bin
    ln -s /usr/bin/xcode-select
    ln -s /usr/bin/security
    ln -s /usr/bin/codesign
    ln -s /usr/bin/xcrun
    ln -s /usr/bin/plutil
    ln -s /usr/bin/clang
    ln -s "${xcodeBaseDir}/Contents/Developer/usr/bin/xcodebuild"
    ln -s "${xcodeBaseDir}/Contents/Developer/Applications/Simulator.app/Contents/MacOS/Simulator"

    cd ..
    ln -s "${xcodeBaseDir}/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs"

    # Check if we have the xcodebuild version that we want
    if [ -z "$($out/bin/xcodebuild -version | grep -x 'Xcode ${version}')" ]
    then
        echo "We require xcodebuild version: ${version}"
        exit 1
    fi
  '';
}
