{ lib, buildDunePackage, fetchurl }:

buildDunePackage rec {
  pname = "atdgen-codec-runtime";
  version = "2.4.1";

  src = fetchurl {
    url = "https://github.com/ahrefs/atd/releases/download/${version}/atdgen-codec-runtime-${version}.tbz";
    sha256 = "sha256:16888rnvhgh5yxxsnzsj10g5pzs1l4dn27n23kk2f4641dn26s3a";
  };

  meta = {
    description = "Runtime for atdgen generated bucklescript converters";
    homepage = "https://github.com/ahrefs/atd";
    maintainers = [ lib.maintainers.vbgl ];
    license = lib.licenses.mit;
  };
}
