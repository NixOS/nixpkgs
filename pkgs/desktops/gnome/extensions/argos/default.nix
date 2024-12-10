{
  fetchFromGitHub,
  lib,
  stdenv,
  unstableGitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "argos";
  version = "unstable-2024-04-03";

  src = fetchFromGitHub {
    owner = "p-e-w";
    repo = "argos";
    rev = "0449229e11bc2bb5c66e6f1d8503635cdf276bcf";
    hash = "sha256-szBk3zW+HzfxTI34lLB1DFdnwZ3W+BgeVgDkwf0UzQU=";
  };

  installPhase = ''
    mkdir -p "$out/share/gnome-shell/extensions"
    cp -a argos@pew.worldwidemann.com "$out/share/gnome-shell/extensions"
  '';

  passthru = {
    extensionUuid = "argos@pew.worldwidemann.com";
    extensionPortalSlug = "argos";
    updateScript = unstableGitUpdater { };
  };

  meta = with lib; {
    description = "Create GNOME Shell extensions in seconds";
    license = licenses.gpl3;
    maintainers = with maintainers; [ andersk ];
    homepage = "https://github.com/p-e-w/argos";
  };
}
