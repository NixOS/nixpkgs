{ stdenvNoCC
, lib
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "dde-account-faces";
  version = "1.0.16";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-PtbEsFQl6M5Ouadxy9CTVh1Bmmect83NODO4Ks+ckKU=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}/var" ];

  meta = with lib; {
    description = "Account faces of deepin desktop environment";
    homepage = "https://github.com/linuxdeepin/dde-account-faces";
    license = with licenses; [ gpl3Plus cc0 ];
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
