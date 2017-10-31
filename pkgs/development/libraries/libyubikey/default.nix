{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libyubikey-1.13";

  src = fetchurl {
    url = "https://developers.yubico.com/yubico-c/Releases/${name}.tar.gz";
    sha256 = "009l3k2zyn06dbrlja2d4p2vfnzjhlcqxi88v02mlrnb17mx1v84";
  };

  meta = with stdenv.lib; {
    homepage = http://opensource.yubico.com/yubico-c/;
    description = "C library for manipulating Yubico YubiKey One-Time Passwords (OTPs)";
    license = licenses.bsd2;
    maintainers = with maintainers; [ calrama wkennington ];
    platforms = platforms.unix;
  };
}
