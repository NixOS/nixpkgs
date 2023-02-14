{ fetchzip, lib }:

fetchzip rec {
  pname = "psol";
  version = "1.14.36.1";

  url = "https://dist.apache.org/repos/dist/release/incubator/pagespeed/${version}/x64/psol-${version}-apache-incubating-x64.tar.gz";
  sha256 = "sha256-fvpjeoEgpSbk376rT1oZrdYAtuoiePbtjEF9lO9xGWc=";

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
