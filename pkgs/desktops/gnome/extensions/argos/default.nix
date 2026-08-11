{
  fetchFromGitHub,
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "argos";
  version = "50";

  src = fetchFromGitHub {
    owner = "p-e-w";
    repo = "argos";
    tag = "GNOME-50";
    hash = "sha256-KwW4Hzp+0TqFU1ygPURNbbT+ZzQN7eocn2R4IJFmNZQ=";
  };

  installPhase = ''
    mkdir -p "$out/share/gnome-shell/extensions"
    cp -a argos@pew.worldwidemann.com "$out/share/gnome-shell/extensions"
  '';

  passthru = {
    extensionUuid = "argos@pew.worldwidemann.com";
    extensionPortalSlug = "argos";
  };

  meta = {
    description = "Create GNOME Shell extensions in seconds";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ andersk ];
    homepage = "https://github.com/p-e-w/argos";
  };
}
