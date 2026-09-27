{
  lib,
  stdenv,
  fetchurl,
  sendmailPath ? "/run/wrappers/bin/sendmail",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ts";
  version = "1.0.4";

  installPhase = ''make install "PREFIX=$out"'';

  patchPhase = ''
    sed -i s,/usr/sbin/sendmail,${sendmailPath}, mail.c ts.1
  '';

  src = fetchurl {
    url = "https://viric.name/~viric/soft/ts/ts-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-sas9tS3KNq82mReLjQ6TajAQf41chql0FjxYCCOwF5A=";
  };

  meta = {
    homepage = "http://vicerveza.homeunix.net/~viric/soft/ts";
    description = "Task spooler - batch queue";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
    platforms = lib.platforms.all;
    mainProgram = "ts";
  };
})
