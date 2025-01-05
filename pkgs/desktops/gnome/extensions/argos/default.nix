{
  fetchFromGitHub,
  lib,
  stdenv,
  unstableGitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "argos";
  version = "unstable-2024-10-28";

  src = fetchFromGitHub {
    owner = "p-e-w";
    repo = "argos";
    rev = "cd0de7c79072979bed41e0ad75741bbd8e113950";
    hash = "sha256-rNS2rvHZOpl9mSoERfsX6UfEaAb6lWTI9y6HXKrl81E=";
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
