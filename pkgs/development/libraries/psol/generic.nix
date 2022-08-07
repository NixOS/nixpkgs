{ fetchzip, lib }:
{ version, sha256 }:
{ inherit version; } // fetchzip {
  inherit sha256;
  name   = "psol-${version}";
  url    = "https://dl.google.com/dl/page-speed/psol/${version}-x64.tar.gz";

  meta = {
    description = "PageSpeed Optimization Libraries";
    homepage    = "https://developers.google.com/speed/pagespeed/psol";
    license     = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    # WARNING: This only works with Linux because the pre-built PSOL binary is only supplied for Linux.
    # TODO: Build PSOL from source to support more platforms.
    platforms   = lib.platforms.linux;
  };
}
