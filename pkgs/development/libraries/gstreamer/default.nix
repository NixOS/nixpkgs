{ buildEnv, lib, gst_all, makeWrapper }:
buildEnv {
  name = gst_all.gstreamer.name;
  paths = with lib; filter isDerivation (attrValues gst_all);

  buildInputs = [ makeWrapper ];

  postBuild = ''
    for prog in $out/bin/*; do
      wrapProgram "$prog" --set GST_PLUGIN_SYSTEM_PATH $out/lib/gstreamer-1.0
    done
  '';

  meta = gst_all.gstreamer.meta // {
    description = "Bundle of GStreamer and all it's plugins";
  };
}
