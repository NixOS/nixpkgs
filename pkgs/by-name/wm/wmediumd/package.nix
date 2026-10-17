{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libconfig,
  libevent,
  libnl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wmediumd";
  version = "unstable-2026-07-23";

  src = fetchFromGitHub {
    owner = "ramonfontes";
    repo = "wmediumd";
    rev = "ebfdc7c600c003885c0e5a5c7dfd2d0b2ae70229";
    hash = "sha256-w8xA8/8RuXqE0gQdaWBqFCDbgeC/SBYfKjBqmASN8nU=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libconfig
    libevent
    libnl
  ];

  strictDeps = true;
  __structuredAttrs = true;

  # Only build the wmediumd binary; the root Makefile would also build tests/.
  buildPhase = ''
    runHook preBuild
    make -C wmediumd
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 wmediumd/wmediumd $out/bin/wmediumd
    runHook postInstall
  '';

  meta = {
    description = "Wireless medium simulator for the mac80211_hwsim kernel module (Mininet-WiFi fork)";
    homepage = "https://github.com/ramonfontes/wmediumd";
    # The repository has no LICENSE file; upstream source headers state
    # "Copyright (c) 2011 cozybit Inc." and GPL-2.0-or-later.
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ jacka10086 ];
    mainProgram = "wmediumd";
    platforms = lib.platforms.linux;
  };
})
