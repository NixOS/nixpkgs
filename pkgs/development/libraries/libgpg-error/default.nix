{ stdenv, lib, buildPackages, fetchurl, gettext
, genPosixLockObjOnly ? false
}: let
  genPosixLockObjOnlyAttrs = lib.optionalAttrs genPosixLockObjOnly {
    buildPhase = ''
      cd src
      make gen-posix-lock-obj
    '';

    installPhase = ''
      mkdir -p $out/bin
      install -m755 gen-posix-lock-obj $out/bin
    '';

    outputs = [ "out" ];
    outputBin = "out";
  };
in stdenv.mkDerivation (rec {
  pname = "libgpg-error";
  version = "1.46";

  src = fetchurl {
    url = "mirror://gnupg/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-t+EaZCRrvl7zd0jeQ7JFq9cs/NU8muXn/FylnxyBJo0=";
  };

  postPatch = ''
    sed '/BUILD_TIMESTAMP=/s/=.*/=1970-01-01T00:01+0000/' -i ./configure
  '';

  configureFlags = [
    # See https://dev.gnupg.org/T6257#164567
    "--enable-install-gpg-error-config"
  ];

  outputs = [ "out" "dev" "info" ];
  outputBin = "dev"; # deps want just the lib, most likely

  # If architecture-dependent MO files aren't available, they're generated
  # during build, so we need gettext for cross-builds.
  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ gettext ];

  postConfigure =
    # For some reason, /bin/sh on OpenIndiana leads to this at the end of the
    # `config.status' run:
    #   ./config.status[1401]: shift: (null): bad number
    # (See <https://hydra.nixos.org/build/2931046/nixlog/1/raw>.)
    # Thus, re-run it with Bash.
    lib.optionalString stdenv.isSunOS ''
      ${stdenv.shell} config.status
    ''
    # ./configure errorneous decides to use weak symbols on pkgsStatic,
    # which, together with other defines results in locking functions in
    # src/posix-lock.c to be no-op, causing tests/t-lock.c to fail.
    + lib.optionalString stdenv.hostPlatform.isStatic ''
      sed '/USE_POSIX_THREADS_WEAK/ d' config.h
      echo '#undef USE_POSIX_THREADS_WEAK' >> config.h
    '';

  doCheck = true; # not cross

  meta = with lib; {
    homepage = "https://www.gnupg.org/software/libgpg-error/index.html";
    changelog = "https://git.gnupg.org/cgi-bin/gitweb.cgi?p=libgpg-error.git;a=blob;f=NEWS;hb=refs/tags/libgpg-error-${version}";
    description = "A small library that defines common error values for all GnuPG components";

    longDescription = ''
      Libgpg-error is a small library that defines common error values
      for all GnuPG components.  Among these are GPG, GPGSM, GPGME,
      GPG-Agent, libgcrypt, Libksba, DirMngr, Pinentry, SmartCard
      Daemon and possibly more in the future.
    '';

    license = licenses.lgpl2Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.vrthra ];
  };
} // genPosixLockObjOnlyAttrs)
