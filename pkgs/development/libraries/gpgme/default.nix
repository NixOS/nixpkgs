{ stdenv, fetchurl, libgpgerror, gnupg, pkgconfig, glib, pth, libassuan
, useGnupg1 ? false, gnupg1 ? null }:

assert useGnupg1 -> gnupg1 != null;
assert !useGnupg1 -> gnupg != null;

let
  gpgStorePath = if useGnupg1 then gnupg1 else gnupg;
  gpgProgram = if useGnupg1 then "gpg" else "gpg2";
in
stdenv.mkDerivation rec {
  name = "gpgme-1.7.0";

  src = fetchurl {
    url = "mirror://gnupg/gpgme/${name}.tar.bz2";
    sha256 = "0j6capvv6lcr6p763lr2ygzkzkj5lqm7fnbfc1xaygib1znmzxbi";
  };

  outputs = [ "out" "dev" "info" ];
  outputBin = "dev"; # gpgme-config; not so sure about gpgme-tool

  propagatedBuildInputs = [ libgpgerror glib libassuan pth ];

  nativeBuildInputs = [ pkgconfig gnupg ];

  configureFlags = [
    "--with-gpg=${gpgStorePath}/bin/${gpgProgram}"
    "--enable-fixed-path=${gpgStorePath}/bin"
  ];

  meta = with stdenv.lib; {
    homepage = "http://www.gnupg.org/related_software/gpgme";
    description = "Library for making GnuPG easier to use";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.fuuzetsu ];
  };
}
