{
  fetchFromGitHub,
  lib,
  stdenv,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "argos";
  version = "unstable-2025-03-27";

  src = fetchFromGitHub {
    owner = "p-e-w";
    repo = "argos";
    rev = "13264042ae8b8a6f9f4778c623780e38e5d1cd89";
    hash = "sha256-PMMpTaihMHj1FmnjJoZqAhDYVd263M1OZAC+OAnaZEg=";
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
