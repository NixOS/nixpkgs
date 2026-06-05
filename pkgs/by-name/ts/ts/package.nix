{
  lib,
  stdenv,
  fetchurl,
  sendmailPath ? "/run/wrappers/bin/sendmail",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ts";
  version = "1.0.3";

  installPhase = ''make install "PREFIX=$out"'';

  patchPhase = ''
    sed -i s,/usr/sbin/sendmail,${sendmailPath}, mail.c ts.1
  '';

  src = fetchurl {
    url = "https://viric.name/~viric/soft/ts/ts-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-+oMzEVQ9xTW2DLerg8ZKte4xEo26qqE93jQZhOVCtCg=";
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
