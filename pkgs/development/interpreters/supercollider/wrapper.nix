{
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
    for exe in $out/bin/*; do
      wrapProgram $exe \
        --set SC_PLUGIN_DIR "$out/lib/SuperCollider/plugins" \
        --set SC_DATA_DIR   "$out/share/SuperCollider"
    done
  '';

  inherit (supercollider) pname version meta;
}
