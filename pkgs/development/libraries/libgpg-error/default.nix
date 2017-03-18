{ stdenv, fetchurl, gettext }:

stdenv.mkDerivation rec {
  name = "libgpg-error-${version}";
  version = "1.27";

  src = fetchurl {
    url = "mirror://gnupg/libgpg-error/${name}.tar.bz2";
    sha256 = "1li95ni122fzinzlmxbln63nmgij63irxfvi52ws4zfbzv3am4sg";
  };

  postPatch = "sed '/BUILD_TIMESTAMP=/s/=.*/=1970-01-01T00:01+0000/' -i ./configure";

  outputs = [ "out" "dev" "info" ];
  outputBin = "dev"; # deps want just the lib, most likely

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

  meta = with stdenv.lib; {
    homepage = "https://www.gnupg.org/related_software/libgpg-error/index.html";
    description = "A small library that defines common error values for all GnuPG components";

    longDescription = ''
      Libgpg-error is a small library that defines common error values
      for all GnuPG components.  Among these are GPG, GPGSM, GPGME,
      GPG-Agent, libgcrypt, Libksba, DirMngr, Pinentry, SmartCard
      Daemon and possibly more in the future.
    '';

    license = licenses.lgpl2Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.fuuzetsu maintainers.vrthra ];
  };
}

