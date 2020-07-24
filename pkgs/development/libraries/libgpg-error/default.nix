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
  version = "1.38";

  src = fetchurl {
    url = "mirror://gnupg/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "00px79xzyc5lj8aig7i4fhk29h1lkqp4840wjfgi9mv9m9sq566q";
  };

  postPatch = ''
    sed '/BUILD_TIMESTAMP=/s/=.*/=1970-01-01T00:01+0000/' -i ./configure
  '' + lib.optionalString (stdenv.hostPlatform.isAarch32 && stdenv.buildPlatform != stdenv.hostPlatform) ''
    ln -s lock-obj-pub.arm-unknown-linux-gnueabi.h src/syscfg/lock-obj-pub.linux-gnueabihf.h
    ln -s lock-obj-pub.arm-unknown-linux-gnueabi.h src/syscfg/lock-obj-pub.linux-gnueabi.h
  '' + lib.optionalString (stdenv.hostPlatform.isx86_64 && stdenv.hostPlatform.isMusl) ''
    ln -s lock-obj-pub.x86_64-pc-linux-musl.h src/syscfg/lock-obj-pub.linux-musl.h
  '' + lib.optionalString (stdenv.hostPlatform.isAarch32 && stdenv.hostPlatform.isMusl) ''
    ln -s src/syscfg/lock-obj-pub.arm-unknown-linux-gnueabi.h src/syscfg/lock-obj-pub.arm-unknown-linux-musleabihf.h
    ln -s src/syscfg/lock-obj-pub.arm-unknown-linux-gnueabi.h src/syscfg/lock-obj-pub.linux-musleabihf.h
  ''
  # This file was accidentally excluded from the sdist until
  # 013720333c6ec1d38791689bc49ba039d98e16b3, post release.
  # TODO make unconditional next mass rebuild
  + lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    cp ${fetchurl {
      url = "https://raw.githubusercontent.com/gpg/libgpg-error/50e62b36ea01ed25d12c443088b85d4f41a2b3e1/src/gen-lock-obj.sh";
      sha256 = "10cslipa6npalj869asaamj0w941dhmx0yjafpyyh69ypsg2m2c3";
    }} ./src/gen-lock-obj.sh
    chmod +x ./src/gen-lock-obj.sh
  '';

  outputs = [ "out" "dev" "info" ];
  outputBin = "dev"; # deps want just the lib, most likely

  # If architecture-dependent MO files aren't available, they're generated
  # during build, so we need gettext for cross-builds.
  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ gettext ];

  postConfigure =
    lib.optionalString stdenv.isSunOS
    # For some reason, /bin/sh on OpenIndiana leads to this at the end of the
    # `config.status' run:
    #   ./config.status[1401]: shift: (null): bad number
    # (See <https://hydra.nixos.org/build/2931046/nixlog/1/raw>.)
    # Thus, re-run it with Bash.
      "${stdenv.shell} config.status";

  doCheck = true; # not cross

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
    maintainers = [ maintainers.vrthra ];
  };
} // genPosixLockObjOnlyAttrs)
