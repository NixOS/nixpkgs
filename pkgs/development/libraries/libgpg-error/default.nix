{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "libgpg-error-1.8";

  src = fetchurl {
    url = "mirror://gnupg/libgpg-error/${name}.tar.bz2";
    sha256 = "1i88jl2jm8ckjzyzk7iw2dydk7sxcd27zqyl4qnrs8s7f5kz5yxx";
  };

  doCheck = true;

  meta = {
    description = "Libgpg-error, a small library that defines common error values for all GnuPG components";

    longDescription = ''
      Libgpg-error is a small library that defines common error values
      for all GnuPG components.  Among these are GPG, GPGSM, GPGME,
      GPG-Agent, libgcrypt, Libksba, DirMngr, Pinentry, SmartCard
      Daemon and possibly more in the future.
    '';

    homepage = http://gnupg.org;

    license = "LGPLv2+";
    platforms = stdenv.lib.platforms.all;
  };
}
