{stdenv, fetchurl}:

stdenv.mkDerivation rec
{
  version = "1.11";
  name = "libyubikey-${version}";

  src = fetchurl
  {
    url = "http://opensource.yubico.com/yubico-c/releases/${name}.tar.gz";
    sha256 = "19pm4rqsnm9r0n5j26bqkxa1jpimdavzcvg5g7p416vkjhxc6lw9";
  };

  meta =
  {
    homepage = "http://opensource.yubico.com/yubico-c/";
    description = "C library for manipulating Yubico YubiKey One-Time Passwords (OTPs)";
    license = "bsd";
    maintainers = [ stdenv.lib.maintainers.calrama ];
  };
}
