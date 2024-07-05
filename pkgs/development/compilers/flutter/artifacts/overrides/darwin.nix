{}:
{ buildInputs ? [ ]
, ...
}:
{
  postPatch = ''
    if [ "$pname" == "flutter-tools" ]; then
      # Use arm64 instead of arm64e.
      substituteInPlace lib/src/ios/xcodeproj.dart \
        --replace-fail arm64e arm64
    fi
  '';
}
