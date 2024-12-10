{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "tbox";
  version = "1.7.5";

  src = fetchFromGitHub {
    owner = "tboox";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-VM6LOTVwM47caXYiH+6c7t174i0W5MY1dg2Y5yutlcc=";
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

  meta = with lib; {
    description = "A glib-like multi-platform c library";
    homepage = "https://docs.tboox.org";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rewine ];
  };
}
