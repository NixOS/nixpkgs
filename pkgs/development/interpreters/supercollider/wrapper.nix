{
  lib,
  symlinkJoin,
  makeWrapper,
  supercollider,
  plugins,
}:

symlinkJoin {
  name = "supercollider-with-plugins-${supercollider.version}";
  paths = [ supercollider ] ++ plugins;

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    # --include-path adds to the paths from the user's language configuration,
    # including an explicit -l configuration (as used by tidal-cycles-full).
    if [ -d "$out/share/SuperCollider/Extensions" ]; then
      wrapProgram "$out/bin/sclang" \
        --add-flags "--include-path $out/share/SuperCollider/Extensions"
    fi

    for exe in $out/bin/*; do
      # scide launches sclang, and sclang launches scsynth, through PATH.
      # The server already loads its core UGens from its compiled-in path.
      wrapProgram "$exe" \
        --prefix PATH : "$out/bin" \
        --prefix SC_PLUGIN_PATH : "${lib.makeSearchPath "lib/SuperCollider/plugins" plugins}"
    done
  '';

  inherit (supercollider) pname version meta;
}
