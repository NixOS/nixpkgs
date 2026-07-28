{
  makeBinaryWrapper,
  makeSetupHook,
  writeScript,
  xbitmaps,
}:

makeSetupHook
  {
    name = "wrapWithXFileSearchPathHook";
    propagatedBuildInputs = [ makeBinaryWrapper ];
  }
  (
    writeScript "wrapWithXFileSearchPathHook.sh" ''
      wrapWithXFileSearchPath() {
        paths=(
          "$out/share/X11/%T/%N"
          "$out/include/X11/%T/%N"
          "${xbitmaps}/include/X11/%T/%N"
        )
        for exe in $out/bin/*; do
          wrapProgram "$exe" \
            --suffix XFILESEARCHPATH : $(IFS=:; echo "''${paths[*]}")
        done
      }
      postInstallHooks+=(wrapWithXFileSearchPath)
    ''
  )
