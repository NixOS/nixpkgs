{ lib, stdenv, fetchFromGitHub, findutils, glib }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-workspace-matrix";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "mzur";
    repo = "gnome-shell-wsmatrix";
    rev = "v${version}";
    sha256 = "sha256-aTS5PsDUHvSch0wX5ei/y5117XVGlHaoRIex+9nxevw=";
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
