{ lib,
  stdenv,
  writeShellScriptBin }:
{ versions ? [ ] , xcodeBaseDir ? "/Applications/Xcode.app" }:

assert stdenv.isDarwin;
let
  xcodebuildPath = "${xcodeBaseDir}/Contents/Developer/usr/bin/xcodebuild";

  xcodebuildWrapper = writeShellScriptBin "xcodebuild" ''
    currentVer="$(${xcodebuildPath} -version | awk 'NR==1{print $2}')"
    wrapperVers=(${lib.concatStringsSep " " versions})

    for ver in "''${wrapperVers[@]}"; do
      if [[ "$currentVer" == "$ver" ]]; then
        # here exec replaces the shell without creating a new process
        # https://www.gnu.org/software/bash/manual/bash.html#index-exec
        exec "${xcodebuildPath}" "$@"
      fi
    done

    echo "The installed Xcode version ($currentVer) does not match any of the allowed versions: ${lib.concatStringsSep ", " versions}"
    echo "Please update your local Xcode installation to match one of the allowed versions"
    exit 1
  '';
in
stdenv.mkDerivation {
  name = "xcode-wrapper-impure";
  # Fails in sandbox. Use `--option sandbox relaxed` or `--option sandbox false`.
  __noChroot = true;
  buildCommand = ''
    mkdir -p $out/bin
    cd $out/bin
    ${if versions == [ ] then ''
    ln -s "${xcodebuildPath}"
    '' else ''
    ln -s "${xcodebuildWrapper}/bin/xcode-select"
    ''}
    ln -s /usr/bin/security
    ln -s /usr/bin/codesign
    ln -s /usr/bin/xcrun
    ln -s /usr/bin/plutil
    ln -s /usr/bin/clang
    ln -s /usr/bin/lipo
    ln -s /usr/bin/file
    ln -s /usr/bin/rev
    ln -s "${xcodeBaseDir}/Contents/Developer/Applications/Simulator.app/Contents/MacOS/Simulator"

    cd ..
    ln -s "${xcodeBaseDir}/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs"
  '';
}
