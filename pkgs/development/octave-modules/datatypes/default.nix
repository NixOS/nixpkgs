{
  buildOctavePackage,
  lib,
  fetchFromGitHub,
  nix-update-script,
}:

buildOctavePackage rec {
  pname = "datatypes";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "pr0m1th3as";
    repo = "datatypes";
    tag = "release-${version}";
    sha256 = "sha256-0RhZm/UzICbAAn1uCSQSgq8+6GnOuTB6TD9NoIEdvXA=";
  };

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=release-(.*)" ]; };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/datatypes/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Extra data types for GNU Octave";
  };
}
