{
  fetchFromGitHub,
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "argos";
  version = "50-unstable-2026-10-19";

  src = fetchFromGitHub {
    owner = "p-e-w";
    repo = "argos";
    rev = "b479bdd5858655652897b91debaf927b56df8022";
    hash = "sha256-ZwGzts6It6D6RLlkE2GD7YZneSo53B4L2wLxmXp9vGg=";
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
