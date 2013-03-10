{ stdenv, fetchurl, alsaLib }:

stdenv.mkDerivation rec {
  name = "lirc-0.9.0";

  src = fetchurl {
    url = "mirror://sourceforge/lirc/${name}.tar.bz2";
    sha256 = "1zx4mcnjwzz6jsi6ln7a3dkgx05nvg1pxxvmjqvd966ldapay8v3";
  };

  buildInputs = [ alsaLib ];

  configureFlags = [
    "--with-driver=devinput"
    "--sysconfdir=$(out)/etc"
    "--enable-sandboxed"
  ];
}
