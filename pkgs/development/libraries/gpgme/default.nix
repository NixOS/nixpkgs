{ stdenv, fetchurl, libgpgerror, gnupg, pkgconfig, glib, pth, libassuan
, useGnupg1 ? false, gnupg1 ? null }:

assert useGnupg1 -> gnupg1 != null;
assert !useGnupg1 -> gnupg != null;

let
  gpgStorePath = if useGnupg1 then gnupg1 else gnupg;
  gpgProgram = if useGnupg1 then "gpg" else "gpg2";
in
stdenv.mkDerivation rec {
  name = "gpgme-1.8.0";

  src = fetchurl {
    url = "mirror://gnupg/gpgme/${name}.tar.bz2";
    sha256 = "0csx3qnycwm0n90ql6gs65if5xi4gqyzzy21fxs2xqicghjrfq2r";
  };

  outputs = [ "out" "dev" "info" ];
  outputBin = "dev"; # gpgme-config; not so sure about gpgme-tool

  propagatedBuildInputs = [ libgpgerror glib libassuan pth ];

  nativeBuildInputs = [ pkgconfig gnupg ];

  configureFlags = [
    "--enable-fixed-path=${gpgStorePath}/bin"
  ];

  NIX_CFLAGS_COMPILE =
    with stdenv; lib.optional (system == "i686-linux") "-D_FILE_OFFSET_BITS=64";

  AM_CXXFLAGS =
    with stdenv; lib.optional (isDarwin) "-D_POSIX_C_SOURCE=200809L";

  meta = with stdenv.lib; {
    homepage = "http://www.gnupg.org/related_software/gpgme";
    description = "Library for making GnuPG easier to use";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.fuuzetsu ];
  };
}
