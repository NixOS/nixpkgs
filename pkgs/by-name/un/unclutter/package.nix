{
  lib,
  stdenv,
  fetchurl,
  libX11,
}:

stdenv.mkDerivation rec {
  pname = "unclutter";
  version = "8";
  src = fetchurl {
    url = "https://www.ibiblio.org/pub/X11/contrib/utilities/unclutter-${version}.tar.gz";
    sha256 = "33a78949a7dedf2e8669ae7b5b2c72067896497820292c96afaa60bb71d1f2a6";
  };

  buildInputs = [ libX11 ];

  buildFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "CFLAGS=-std=c89"
  ];

  installFlags = [
    "DESTDIR=${placeholder "out"}"
    "BINDIR=${placeholder "out"}/bin"
    "MANPATH=${placeholder "out"}/share/man"
  ];

  installTargets = [
    "install"
    "install.man"
  ];

  preInstall = ''
    mkdir -pv "$out"/{bin,share/man/man1}
  '';

  meta = with lib; {
    description = "Hides mouse pointer while not in use";
    longDescription = ''
      Unclutter hides your X mouse cursor when you do not need it, to prevent
      it from getting in the way. You have only to move the mouse to restore
      the mouse cursor. Unclutter is very useful in tiling wm's where you do
      not need the mouse often.

      Just run it from your .bash_profile like that:

          unclutter -idle 1 &
    '';
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
    license = lib.licenses.publicDomain;
    mainProgram = "unclutter";
  };
}
