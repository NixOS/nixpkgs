{ stdenv, fetchFromGitHub, findutils, glib }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-workspace-matrix";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "mzur";
    repo = "gnome-shell-wsmatrix";
    rev = "v${version}";
    sha256 = "LTDkKSKvReJxBzAERE+vV+uJBNZw6UyhiB7kN48BZCo=";
  };

  uuid = "wsmatrix@martin.zurowietz.de";

  nativeBuildInputs = [
    findutils
    glib
  ];

  buildFlags = "schemas";

  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions
    cp -r ${uuid} $out/share/gnome-shell/extensions
  '';

  meta = with stdenv.lib; {
    description = "Arrange workspaces in a two dimensional grid with workspace thumbnails";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chkno ];
    homepage =  https://github.com/mzur/gnome-shell-wsmatrix;
  };
}
