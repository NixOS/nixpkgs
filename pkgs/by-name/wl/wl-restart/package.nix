{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  scdoc,
  nix-update-script,
}:
stdenv.mkDerivation {
  pname = "wl-restart";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "Ferdi265";
    repo = "wl-restart";
    rev = "v0.2.0";
    hash = "sha256-pMsYLU9pjN2cgz7FxJJwkDHKJt1mIAuagJSBjrPUMAM=";
  };

  nativeBuildInputs = [
    cmake
    scdoc
  ];

  cmakeFlags = [ "-DINSTALL_DOCUMENTATION=ON" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "seamlessly restart your wayland compositor when it crashes";
    mainProgram = "wl-restart";
    license = lib.licenses.gpl3;
    homepage = "https://github.com/Ferdi265/wl-restart";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ _0x5a4 ];
  };
}
