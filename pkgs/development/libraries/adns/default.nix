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
  doCheck = 1;

  # adns doesn't understand the automatic --disable-shared from the Cygwin stdenv.
  cygwinConfigureEnableShared = true;
}
