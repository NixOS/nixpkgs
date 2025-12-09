{
  fetchFromGitHub,
  lib,
  stdenv,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "argos";
  version = "unstable-2025-09-25";

  src = fetchFromGitHub {
    owner = "p-e-w";
    repo = "argos";
    rev = "c0dc23880e52a2f78b7a5c35b5b3781d5b1366f7";
    hash = "sha256-A/ugbKxnUJdoMN724ECtRm0QWwCVopmbltt+fUKBp7E=";
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
