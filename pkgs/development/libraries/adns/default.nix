{ stdenv, fetchurl, version, versionHash, static }:

stdenv.mkDerivation
{
  name = "adns-${version}";
  meta =
  {
    homepage = "http://www.chiark.greenend.org.uk/~ian/adns/";
    description = "Asynchronous DNS Resolver Library";
    license = "LGPL-v2";
  };
  src = fetchurl
  {
    url = "ftp://ftp.chiark.greenend.org.uk/users/ian/adns/adns-${version}.tar.gz";
    sha256 = "${versionHash}";
  };
  configureFlags = if static then "--disable-dynamic" else "--enable-dynamic";
  CPPFLAGS = "-DNDEBUG";
  CFLAGS = "-O3";

  # FIXME: The test suite fails on NixOS in a chroot.  See
  # http://thread.gmane.org/gmane.linux.distributions.nixos/1328 for details.
  doCheck = false;

  # adns doesn't understand the automatic --disable-shared from the Cygwin stdenv.
  cygwinConfigureEnableShared = true;
}
