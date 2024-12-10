{
  lib,
  stdenv,
  fetchFromGitLab,
  wayland-scanner,
}:

stdenv.mkDerivation {
  pname = "wlr-protocols";
  version = "unstable-2022-09-05";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "wlroots";
    repo = "wlr-protocols";
    rev = "4264185db3b7e961e7f157e1cc4fd0ab75137568";
    sha256 = "Ztc07RLg+BZPondP/r6Jo3Fw1QY/z1QsFvdEuOqQshA=";
  };

  strictDeps = true;
  nativeBuildInputs = [ wayland-scanner ];

  patchPhase = ''
    substituteInPlace wlr-protocols.pc.in \
      --replace '=''${pc_sysrootdir}' "=" \
      --replace '=@prefix@' "=$out"
  '';

  doCheck = true;
  checkTarget = "check";

  installFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  meta = with lib; {
    description = "Wayland roots protocol extensions";
    longDescription = ''
      wlr-protocols contains Wayland protocols that add functionality not
      available in the Wayland core protocol, and specific to wlroots-based
      compositors. Such protocols either add completely new functionality, or
      extend the functionality of some other protocol either in Wayland core,
      or some other protocol in wayland-protocols.
    '';
    homepage = "https://gitlab.freedesktop.org/wlroots/wlr-protocols";
    license = licenses.mit; # See file headers
    platforms = platforms.linux;
    maintainers = with maintainers; [ Scrumplex ];
  };
}
