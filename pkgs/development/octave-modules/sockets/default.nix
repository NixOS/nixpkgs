{
  buildOctavePackage,
  lib,
  fetchFromGitHub,
  nix-update-script,
}:

buildOctavePackage rec {
  pname = "sockets";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "gnu-octave";
    repo = "octave-sockets";
    tag = "release-${version}";
    sha256 = "sha256-l5W/mLYVcTRYKLCzM8MQW7nad+Gq0fy2XKQmdH8GG/Y=";
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "release-(.*)"
    ];
  };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/sockets/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Socket functions for networking from within octave";
  };
}
