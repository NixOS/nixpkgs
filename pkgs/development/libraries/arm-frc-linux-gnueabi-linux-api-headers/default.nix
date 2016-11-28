{stdenv, fetchurl}:

let
  _target = "arm-frc-linux-gnueabi";
  _basever = "3.16-r0.40";
  src = fetchurl {
    url = "http://download.ni.com/ni-linux-rt/feeds/2015/arm/ipk/cortexa9-vfpv3/linux-libc-headers-dev_${_basever}_cortexa9-vfpv3.ipk";
    sha256 = "099b67fa1a2dea7730b1ec810fc61448b94459e68e9d640b02d095ffdebff2bb";
  };
in
stdenv.mkDerivation rec {
  version = "3.16";
  name = "${_target}-linux-api-headers-${version}";

  sourceRoot = ".";
  inherit src;

  phases = [ "unpackPhase" "installPhase" ];

  unpackCmd = ''
      ar x $curSrc
      tar xf data.tar.gz
  '';

  installPhase = ''
    mkdir -p $out/usr/${_target}/usr
    find . \( -name .install -o -name ..install.cmd \) -delete
    cp -r ./* $out/usr/${_target}/usr
  '';
}
