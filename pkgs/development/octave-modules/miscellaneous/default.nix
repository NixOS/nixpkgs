{
  buildOctavePackage,
  lib,
  fetchFromGitHub,
  nix-update-script,
  # Build-time dependencies
  ncurses, # >= 5
  units,
}:

buildOctavePackage rec {
  pname = "miscellaneous";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "gnu-octave";
    repo = "octave-miscellaneous";
    tag = "release-${version}";
    sha256 = "sha256-LuqRQefT2Z73113C18YSNvd9OBSr8GFBVVRZw/ucB7k=";
  };

  buildInputs = [
    ncurses
  ];

  propagatedBuildInputs = [
    units
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "release-(.*)"
    ];
  };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/miscellaneous/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ravenjoad ];
    description = "Miscellaneous tools that don't fit somewhere else";
  };
}
