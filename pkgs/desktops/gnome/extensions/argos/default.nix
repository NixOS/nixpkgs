{ fetchFromGitHub, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "argos-unstable";
  version = "20220930";

  src = fetchFromGitHub {
    owner = "p-e-w";
    repo = "argos";
    rev = "f5f6f5bf6ab33dd2d65a490efe8faac5a0c07dc6";
    hash = "sha256-kI8EpZ68loM5oOS9Dkde+dkldD08mo9VcDqNhecyTOU=";
  };

  installPhase = ''
    mkdir -p "$out/share/gnome-shell/extensions"
    cp -a argos@pew.worldwidemann.com "$out/share/gnome-shell/extensions"
  '';

  passthru = {
    extensionUuid = "argos@pew.worldwidemann.com";
    extensionPortalSlug = "argos";
  };

  meta = with lib; {
    description = "Create GNOME Shell extensions in seconds";
    license = licenses.gpl3;
    maintainers = with maintainers; [ andersk ];
    homepage = "https://github.com/p-e-w/argos";
  };
}
