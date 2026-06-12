{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  gd,
  ncurses,
  sqlite,
  check,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vnstat";
  version = "2.13";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "vergoh";
    repo = "vnstat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Xd3s4Wrtfwis0dxRijeWhfloHcXPUNAj0P91uWi1C3M=";
  };

  strictDeps = true;

  postPatch = ''
    substituteInPlace src/cfg.c --replace-fail /usr/local $out
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    gd
    ncurses
    sqlite
  ];

  checkInputs = [ check ];

  doCheck = true;

  meta = {
    description = "Console-based network statistics utility for Linux";
    longDescription = ''
      vnStat is a console-based network traffic monitor for Linux and BSD that
      keeps a log of network traffic for the selected interface(s). It uses the
      network interface statistics provided by the kernel as information source.
      This means that vnStat won't actually be sniffing any traffic and also
      ensures light use of system resources.
    '';
    mainProgram = "vnstat";
    homepage = "https://humdi.net/vnstat/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ choco98 ];
    hasNoMaintainersButDependents = true;
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
