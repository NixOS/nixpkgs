args:
args.stdenv.mkDerivation rec {
  version = "snapshot-20080521-2245";
  name = "x264-${version}";

  src = args.fetchurl {
    url = "ftp://ftp.videolan.org/pub/videolan/x264/snapshots/x264-${version}.tar.bz2";
    sha256 = "07khxih1lmhvrzlaksqmaghbi8w2yyjrjcw867gi2y4z1h0ndhks";
  };

  buildInputs =(with args; []);

  meta = { 
      description = "library for encoding H264/AVC video streams";
      homepage = http://www.videolan.org/developers/x264.html;
      license = "GPL";
  };
}
