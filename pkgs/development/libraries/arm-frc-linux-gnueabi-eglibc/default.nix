{stdenv, fetchurl, arm-frc-linux-gnueabi-linux-api-headers}:

let
  _target = "arm-frc-linux-gnueabi";
  _basever = "2.21-r0.83";
  srcs = [
    (fetchurl {
      url = "http://download.ni.com/ni-linux-rt/feeds/2016/arm/ipk/cortexa9-vfpv3/libc6_${_basever}_cortexa9-vfpv3.ipk";
      sha256 = "117058215440e258027bb9ff18db63c078d55288787dbedfcd5730c06c7a1ae9";
    })
    (fetchurl {
      url = "http://download.ni.com/ni-linux-rt/feeds/2016/arm/ipk/cortexa9-vfpv3/libc6-dev_${_basever}_cortexa9-vfpv3.ipk";
      sha256 = "e28b05d498c1160949f51539270035e12c5bb9d75d68df1f5f111a8fc087f3a6";
    })
    (fetchurl {
      url = "http://download.ni.com/ni-linux-rt/feeds/2016/arm/ipk/cortexa9-vfpv3/libcidn1_${_basever}_cortexa9-vfpv3.ipk";
      sha256 = "0f7372590abf69da54a9b7db8f944cf6c48d9ac8a091218ee60f84fdd9de2398";
    })
    (fetchurl {
      url = "http://download.ni.com/ni-linux-rt/feeds/2016/arm/ipk/cortexa9-vfpv3/libc6-thread-db_${_basever}_cortexa9-vfpv3.ipk";
      sha256 = "5a839498507a0b63165cb7a78234d7eb2ee2bb6a046bff586090f2e70e0e2bfb";
    })
    (fetchurl {
      url = "http://download.ni.com/ni-linux-rt/feeds/2016/arm/ipk/cortexa9-vfpv3/libc6-extra-nss_${_basever}_cortexa9-vfpv3.ipk";
      sha256 = "d765d43c8ec95a4c64fa38eddf8cee848fd090d9cc5b9fcda6d2c9b03d2635c5";
    })
  ];
in
stdenv.mkDerivation rec {
  version = "2.21";
  name = "${_target}-eglibc-${version}";

  sourceRoot = ".";
  inherit srcs;

  phases = [ "unpackPhase" "installPhase" ];

  unpackCmd = ''
      ar x $curSrc
      tar xf data.tar.gz
  '';

  installPhase = ''
    mkdir -p $out/${_target}
    rm -rf lib/eglibc
    find . \( -name .install -o -name ..install.cmd \) -delete
    cp -r lib $out/${_target}
    cp -r usr $out/${_target}

    cp -r ${arm-frc-linux-gnueabi-linux-api-headers}/* $out
  '';

  meta = {
    description = "FRC standard C lib";
    longDescription = ''
      eglibc library for the NI RoboRio to be used in compiling frc user
      programs.
    '';
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.colescott ];
    platforms = stdenv.lib.platforms.linux;

    priority = 2;
  };
}
