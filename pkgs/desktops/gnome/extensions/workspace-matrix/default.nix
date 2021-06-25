{ lib, stdenv, fetchFromGitHub, findutils, glib }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-workspace-matrix";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "mzur";
    repo = "gnome-shell-wsmatrix";
    rev = "v${version}";
    sha256 = "0dbn6b3fdd7yblk0mhsmaiqs3mwgcf3khkx1dsnlqn5hcs0a3myd";
  };

  uuid = "wsmatrix@martin.zurowietz.de";

  nativeBuildInputs = [
    findutils
    glib
  ];

  buildFlags = "schemas";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions
    cp -r ${uuid} $out/share/gnome-shell/extensions
    runHook postInstall
  '';

  meta = with lib; {
    description = "Arrange workspaces in a two dimensional grid with workspace thumbnails";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chkno ];
    homepage =  "https://github.com/mzur/gnome-shell-wsmatrix";
  };
}
