{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libyubikey-1.12";

  src = fetchurl {
    url = "https://developers.yubico.com/yubico-c/Releases/${name}.tar.gz";
    sha256 = "1f0plzmr1gwry4rfgq9q70v6qwqny009hac289ad5m6sj7vqflxr";
  };

  meta = with stdenv.lib; {
    homepage = "http://opensource.yubico.com/yubico-c/";
    description = "C library for manipulating Yubico YubiKey One-Time Passwords (OTPs)";
    license = licenses.bsd2;
    maintainers = with maintainers; [ calrama wkennington ];
    platforms = platforms.unix;
  };
}
