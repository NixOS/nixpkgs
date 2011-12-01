{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "libgpg-error-1.10";

  src = fetchurl {
    url = "mirror://gnupg/libgpg-error/${name}.tar.bz2";
    sha256 = "0cal3jdnzdailr13qcy74grfbplbghkgr3qwk6qjjp4bass2j1jj";
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
