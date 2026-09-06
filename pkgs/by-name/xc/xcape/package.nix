{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pkg-config,
  libx11,
  libxtst,
  xorgproto,
  libxi,
}:

stdenv.mkDerivation {
  pname = "xcape";
  version = "1.2";

  src = fetchurl {
    url = "http://deb.debian.org/debian/pool/main/x/xcape/xcape_1.2.orig.tar.gz";
    hash = "sha256-on7YhP2U8DBYr2Wjnt/jrz8vj7t2upkgACp2vgf7KCE=";
  };

  patches = [
    (fetchpatch {
      url = "https://sources.debian.org/data/main/x/xcape/1.2-3/debian/patches/0001-Fix-cross-building-by-removing-hard-coded-pkg-config.patch";
      hash = "sha256-uQNy7EIQdAO5iHYNA2pBoDltNrn1xrfAAjN/ZdGGa4s=";
    })
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libx11
    libxtst
    xorgproto
    libxi
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "MANDIR=/share/man/man1"
  ];

  postInstall = "install -Dm444 --target-directory $out/share/doc README.md";

  meta = {
    description = "Utility to configure modifier keys to act as other keys";
    longDescription = ''
      xcape allows you to use a modifier key as another key when
      pressed and released on its own.  Note that it is slightly
      slower than pressing the original key, because the pressed event
      does not occur until the key is released.  The default behaviour
      is to generate the Escape key when Left Control is pressed and
      released on its own.
    '';
    homepage = "https://github.com/alols/xcape";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.linux;
    mainProgram = "xcape";
  };
}
