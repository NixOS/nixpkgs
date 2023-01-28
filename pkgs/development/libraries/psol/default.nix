{ fetchzip, lib }:

fetchzip rec {
  pname = "psol";
  version = "1.13.35.2"; # Latest stable, 2018-02-05

  url = "https://dl.google.com/dl/page-speed/psol/${version}-x64.tar.gz";
  sha256 = "0xi2srf9gx0x2sz9r45zb35k2n0iv457if1lqzvbanls3f935cmr";

  meta = with lib; {
    description = "PageSpeed Optimization Libraries";
    homepage = "https://developers.google.com/speed/pagespeed/psol";
    license = licenses.asl20;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    # WARNING: This only works with Linux because the pre-built PSOL binary is only supplied for Linux.
    # TODO: Build PSOL from source to support more platforms.
    platforms = platforms.linux;
  };
}
