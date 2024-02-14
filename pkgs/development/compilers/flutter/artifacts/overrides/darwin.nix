{ darwin }:
{
  buildInputs ? [ ],
  ...
}:
{
  postPatch = ''
    if [ "$pname" == "flutter-tools" ]; then
      # Remove impure references to `arch` and use arm64 instead of arm64e.
      substituteInPlace lib/src/ios/xcodeproj.dart \
        --replace-fail /usr/bin/arch '${darwin.adv_cmds}/bin/arch' \
        --replace-fail arm64e arm64
    fi
  '';
}
