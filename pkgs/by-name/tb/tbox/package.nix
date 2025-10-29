{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "tbox";
  version = "1.7.8";

  src = fetchFromGitHub {
    owner = "tboox";
    repo = "tbox";
    rev = "v${version}";
    hash = "sha256-lAuazxlPOfZ7gWGS0pQ22Yk3PjgrB9wlxNkq1TTVEoM=";
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
}
