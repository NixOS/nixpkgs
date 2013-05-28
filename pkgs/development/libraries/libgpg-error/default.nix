{ stdenv, fetchurl, bash }:

stdenv.mkDerivation (rec {
  name = "libgpg-error-1.11";

  src = fetchurl {
    url = "mirror://gnupg/libgpg-error/${name}.tar.bz2";
    sha1 = "be209b013652add5c7e2c473ea114f58203cc6cd";
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

//

(stdenv.lib.optionalAttrs stdenv.isSunOS {
  # For some reason, /bin/sh on OpenIndiana leads to this at the end of the
  # `config.status' run:
  #   ./config.status[1401]: shift: (null): bad number
  # (See <http://hydra.nixos.org/build/2931046/nixlog/1/raw>.)
  # Thus, re-run it with Bash.
  postConfigure =
    '' ${bash}/bin/sh config.status
    '';
}))
