{ stdenv, fetchurl, gettext }:

stdenv.mkDerivation rec {
  name = "libgpg-error-1.18";

  src = fetchurl {
    url = "mirror://gnupg/libgpg-error/${name}.tar.bz2";
    sha256 = "0408v19h3h0q6w61g51hgbdg6cyw81nyzkh70qfprvsc3pkddwcz";
  };

  postPatch = "sed '/BUILD_TIMESTAMP=/s/=.*/=1970-01-01T00:01+0000/' -i ./configure";

  # If architecture-dependent MO files aren't available, they're generated
  # during build, so we need gettext for cross-builds.
  crossAttrs.buildInputs = [ gettext ];

  postConfigure =
    stdenv.lib.optionalString stdenv.isSunOS
    # For some reason, /bin/sh on OpenIndiana leads to this at the end of the
    # `config.status' run:
    #   ./config.status[1401]: shift: (null): bad number
    # (See <http://hydra.nixos.org/build/2931046/nixlog/1/raw>.)
    # Thus, re-run it with Bash.
      "${stdenv.shell} config.status";

  doCheck = true;

  meta = {
    homepage = "https://www.gnupg.org/related_software/libgpg-error/index.html";
    description = "A small library that defines common error values for all GnuPG components";

    longDescription = ''
      Libgpg-error is a small library that defines common error values
      for all GnuPG components.  Among these are GPG, GPGSM, GPGME,
      GPG-Agent, libgcrypt, Libksba, DirMngr, Pinentry, SmartCard
      Daemon and possibly more in the future.
    '';

    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}

