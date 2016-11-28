{stdenv, fetchurl, arm-frc-linux-gnueabi-linux-api-headers}:

let
  _target = "arm-frc-linux-gnueabi";
  _basever = "2.20-r0.56";
  srcs = [
    (fetchurl {
      url = "http://download.ni.com/ni-linux-rt/feeds/2015/arm/ipk/cortexa9-vfpv3/libc6_${_basever}_cortexa9-vfpv3.ipk";
      sha256 = "3b01e811b0ec2f9b65ddb7dc672eb1e37199674a7d089a85ebc41e43e1ae1d8f";
    })
    (fetchurl {
      url = "http://download.ni.com/ni-linux-rt/feeds/2015/arm/ipk/cortexa9-vfpv3/libc6-dev_${_basever}_cortexa9-vfpv3.ipk";
      sha256 = "33d36bab1e9de066152818f52c98dee4f2cc883037c1a899e2ea7879d6ceedb1";
    })
    (fetchurl {
      url = "http://download.ni.com/ni-linux-rt/feeds/2015/arm/ipk/cortexa9-vfpv3/libcidn1_${_basever}_cortexa9-vfpv3.ipk";
      sha256 = "bf0aeae26789ee0b0f96bd070e57f07300a16d6ab401b9816870b0e58bf42e1a";
    })
    (fetchurl {
      url = "http://download.ni.com/ni-linux-rt/feeds/2015/arm/ipk/cortexa9-vfpv3/libc6-thread-db_${_basever}_cortexa9-vfpv3.ipk";
      sha256 = "c8988fbb87e6d1dda2d294045f746b11baa9ae41bafd867c2a716350992c7b31";
    })
    (fetchurl {
      url = "http://download.ni.com/ni-linux-rt/feeds/2015/arm/ipk/cortexa9-vfpv3/libc6-extra-nss_${_basever}_cortexa9-vfpv3.ipk";
      sha256 = "f477236bdc534ac2d05f68671a3e108782acbfd68ed7e30408d5de2ff50b695f";
    })
  ];
in
stdenv.mkDerivation rec {
  version = "2.20";
  name = "${_target}-eglibc-${version}";

  sourceRoot = ".";
  inherit srcs;

  phases = [ "unpackPhase" "installPhase" ];

  buildInputs = [arm-frc-linux-gnueabi-linux-api-headers];

  unpackCmd = ''
      ar x $curSrc
      tar xf data.tar.gz
  '';

  installPhase = ''
    mkdir -p $out/usr/${_target}
    rm -rf lib/eglibc
    find . \( -name .install -o -name ..install.cmd \) -delete
    cp -r lib $out/usr/${_target}
    cp -r usr $out/usr/${_target}
  '';
}
