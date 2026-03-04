{
  buildOctavePackage,
  lib,
  fetchFromGitHub,
  nix-update-script,
}:

buildOctavePackage rec {
  pname = "windows";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "gnu-octave";
    repo = "octave-windows";
    tag = "release-${version}";
    sha256 = "sha256-hr94VALlAEwpqNU7imEN63M0BdPFSu5IznhWOn/mNiQ=";
  };

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=release-(.*)" ]; };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/windows/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Provides COM interface and additional functionality on Windows";
    broken = true;
  };
}
