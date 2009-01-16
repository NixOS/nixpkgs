{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "libgpg-error-1.7";

  src = fetchurl {
    url = "mirror://gnupg/libgpg-error/${name}.tar.bz2";
    sha256 = "14as9cpm4k9c6lxm517s9vzqrmjmdpf8i4s41k355xc27qdk6083";
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
  };    
}
