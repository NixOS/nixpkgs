{ fetchFromGitHub, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "argos-unstable";
  version = "20230404";

  src = fetchFromGitHub {
    owner = "p-e-w";
    repo = "argos";
    rev = "e2d68ea23eed081fccaec06c384e2c5d2acb5b6b";
    hash = "sha256-OJ/bUQkBQdlfEIqmneyUeIJoytTxyfibdyUDf3SJc0Q=";
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
