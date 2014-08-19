{ stdenv, fetchurl, bash, gettext }:

stdenv.mkDerivation (rec {
  name = "libgpg-error-1.12";

  src = fetchurl {
    url = "mirror://gnupg/libgpg-error/${name}.tar.bz2";
    sha256 = "0pz58vr12qihq2f0bypjxsb6cf6ajq5258fmfm8s6lvwm3b9xz6a";
  };

  # If architecture-dependant MO files aren't available, they're generated
  # during build, so we need gettext for cross-builds.
  crossAttrs.buildInputs = [ gettext ];

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

    license = stdenv.lib.licenses.lgpl2Plus;
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
