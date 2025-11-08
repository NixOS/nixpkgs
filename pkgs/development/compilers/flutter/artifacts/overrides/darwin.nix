{ }:
{
  buildInputs ? [ ],
  ...
}:
{
  # Use arm64 instead of arm64e.
  postPatch = ''
    if [ "$pname" == "flutter-tools" ]; then
      substituteInPlace lib/src/ios/xcodeproj.dart \
        --replace-fail arm64e arm64
    fi
  '';
}
