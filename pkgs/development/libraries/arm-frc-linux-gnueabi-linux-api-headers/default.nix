{stdenv, fetchurl}:

let
  _target = "arm-frc-linux-gnueabi";
  _basever = "3.19-r0.36";
  src = fetchurl {
    url = "http://download.ni.com/ni-linux-rt/feeds/2016/arm/ipk/cortexa9-vfpv3/linux-libc-headers-dev_${_basever}_cortexa9-vfpv3.ipk";
    sha256 = "10066ddb9a19bf764a9a67919a7976478041e98c44c19308f076c78ecb07408c";
  };
in
stdenv.mkDerivation rec {
  version = "3.19";
  name = "${_target}-linux-api-headers-${version}";

  sourceRoot = ".";
  inherit src;

  phases = [ "unpackPhase" "installPhase" ];

  unpackCmd = ''
    ar x $curSrc
    tar xf data.tar.gz
  '';

  installPhase = ''
    mkdir -p $out/${_target}
    find . \( -name .install -o -name ..install.cmd \) -delete
    cp -r usr/ $out/${_target}
  '';

  meta = {
    description = "FRC linux api headers";
    longDescription = ''
      All linux api headers required to compile the arm-frc-linux-gnuaebi-gcc
      cross compiler and all user programs.
    '';
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.colescott ];
    platforms = stdenv.lib.platforms.linux;

    priority = 1;
  };
}
