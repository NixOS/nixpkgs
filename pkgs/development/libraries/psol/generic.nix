{ fetchzip, stdenv }:
{ version, sha256 }:
{ inherit version; } // fetchzip {
  inherit sha256;
  name   = "psol-${version}";
  url    = "https://dl.google.com/dl/page-speed/psol/${version}.tar.gz";

  meta = {
    description = "PageSpeed Optimization Libraries";
    homepage    = "https://developers.google.com/speed/pagespeed/psol";
    license     = stdenv.lib.licenses.asl20;
    # WARNING: This only works with Linux because the pre-built PSOL binary is only supplied for Linux.
    # TODO: Build PSOL from source to support more platforms.
    platforms   = stdenv.lib.platforms.linux;
  };
}
