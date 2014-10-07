{stdenv, fetchurl}:

stdenv.mkDerivation rec
{
  version = "1.12";
  name = "libyubikey-${version}";

  src = fetchurl
  {
    url = "http://opensource.yubico.com/yubico-c/releases/${name}.tar.gz";
    sha256 = "1f0plzmr1gwry4rfgq9q70v6qwqny009hac289ad5m6sj7vqflxr";
  };

  meta =
  {
    homepage = "http://opensource.yubico.com/yubico-c/";
    description = "C library for manipulating Yubico YubiKey One-Time Passwords (OTPs)";
    license = "bsd";
    maintainers = [ stdenv.lib.maintainers.calrama ];
  };
}
