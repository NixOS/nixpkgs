{ lib, stdenv, fetchurl, nixosTests }:

stdenv.mkDerivation rec {
  pname = "trezor-udev-rules";
  version = "unstable-2019-07-17";

  udevRules = fetchurl {
    # let's pin the latest commit in the repo which touched the udev rules file
    url = "https://raw.githubusercontent.com/trezor/trezor-firmware/68a3094b0a8e36b588b1bcb58c34a2c9eafc0dca/common/udev/51-trezor.rules";
    sha256 = "0vlxif89nsqpbnbz1vwfgpl1zayzmq87gw1snskn0qns6x2rpczk";
  };

  dontUnpack = true;

  installPhase = ''
    cp ${udevRules} 51-trezor.rules
    mkdir -p $out/lib/udev/rules.d
    # we use trezord group, not plugdev
    # we don't need the udev-acl tag
    substituteInPlace 51-trezor.rules \
      --replace 'GROUP="plugdev"' 'GROUP="trezord"' \
      --replace ', TAG+="udev-acl"' ""
    cp 51-trezor.rules $out/lib/udev/rules.d/51-trezor.rules
  '';

  passthru.tests = { inherit (nixosTests) trezord; };

  meta = with lib; {
    description = "Udev rules for Trezor";
    license = licenses.gpl3;
    maintainers = with maintainers; [ prusnak ];
    platforms = platforms.linux;
    homepage = "https://github.com/trezor/trezor-firmware/tree/master/common/udev";
  };
}
