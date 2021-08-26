{ lib, stdenv
, fetchFromGitHub
, pkg-config
, gtk3
, thunar
, cmake
, ninja
, xfce
}:

stdenv.mkDerivation rec {
  pname  = "thunar-dropbox";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "Jeinzi";
    repo = "thunar-dropbox";
    rev = version;
    sha256 = "sha256-q7tw/1JgEn9SyjH1KBZl0tintWJjd3ctUs4JUuCWULs=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    ninja
  ];

  buildInputs = [
    thunar
    gtk3
  ];

  passthru.updateScript = xfce.updateScript {
    inherit pname version;
    attrPath = "xfce.thunar-dropbox-plugin";
    versionLister = xfce.gitLister src.meta.homepage;
  };

  meta = with lib; {
    homepage = "https://github.com/Jeinzi/thunar-dropbox";
    description = "A plugin that adds context-menu items for Dropbox to Thunar";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
  };
}
