{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tbox";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "tboox";
    repo = "tbox";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tUN9H6TejbFbJR4Lr0N8HoYkRAo8a/Rh4HEMOG1aPoE=";
  };

  configureFlags = [
    "--hash=y"
    "--charset=y"
    "--float=y"
    "--demo=n"
  ];

  postInstall = ''
    mkdir -p $out/lib/pkgconfig
    substituteAll ${./libtbox.pc.in} $out/lib/pkgconfig/libtbox.pc
  '';

  meta = {
    description = "Glib-like multi-platform c library";
    homepage = "https://docs.tboox.org";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ wineee ];
  };
})
