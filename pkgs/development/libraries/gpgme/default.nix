{ stdenv, fetchurl, libgpgerror, gnupg, pkgconfig, glib, pth, libassuan
, useGnupg1 ? false, gnupg1 ? null }:

assert useGnupg1 -> gnupg1 != null;
assert !useGnupg1 -> gnupg != null;

let
  gpgStorePath = if useGnupg1 then gnupg1 else gnupg;
  gpgProgram = if useGnupg1 then "gpg" else "gpg2";
in
stdenv.mkDerivation rec {
  name = "gpgme-1.6.0";

  src = fetchurl {
    url = "mirror://gnupg/gpgme/${name}.tar.bz2";
    sha256 = "17892sclz3yg45wbyqqrzzpq3l0icbnfl28f101b3062g8cy97dh";
  };

  propagatedBuildInputs = [ libgpgerror glib libassuan pth ];

  nativeBuildInputs = [ pkgconfig gnupg ];

  configureFlags = [
    "--with-gpg=${gpgStorePath}/bin/${gpgProgram}"
    "--enable-fixed-path=${gpgStorePath}/bin"
  ];

  meta = {
    homepage = "http://www.gnupg.org/related_software/gpgme";
    description = "Library for making GnuPG easier to use";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
