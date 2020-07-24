{ stdenv, fetchFromGitHub, findutils, glib }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-workspace-matrix";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "mzur";
    repo = "gnome-shell-wsmatrix";
    rev = "v${version}";
    sha256 = "1xx2h8k981657lws614f7x4mqjk900xq9907j2h5jdhbbic5ppy6";
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

  meta = with stdenv.lib; {
    description = "Arrange workspaces in a two dimensional grid with workspace thumbnails";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chkno ];
    homepage =  "https://github.com/mzur/gnome-shell-wsmatrix";
  };
}
