{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "snapshot-20100429-2245";
  name = "x264-${version}";

  src = fetchurl {
    url = "ftp://ftp.videolan.org/pub/videolan/x264/snapshots/x264-${version}.tar.bz2";
    sha256 = "16b24mc63zyp4h4fqyvgzbdclnhpay4l72yfqzwnzsnlby94zwcj";
  };

  patchPhase = ''
    sed -i s,/bin/bash,${stdenv.bash}/bin/bash, configure version.sh
  '';

  configureFlags = [ "--disable-asm" "--enable-shared" ];

  meta = { 
      description = "library for encoding H264/AVC video streams";
      homepage = http://www.videolan.org/developers/x264.html;
      license = "GPL";
  };
}
