{ stdenv
, fetchFromGitHub
, pkgconfig
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
    sha256 = "1fshjvh542ffa8npfxv3cassgn6jclb2ix9ir997y4k0abzp1fxb";
  };

  nativeBuildInputs = [
    pkgconfig
    cmake
    ninja
  ];

  buildInputs = [
    thunar
    gtk3
  ];

  enableParallelBuilding = true;

  passthru.updateScript = xfce.updateScript {
    inherit pname version;
    attrPath = "xfce.thunar-dropbox-plugin";
    versionLister = xfce.gitLister src.meta.homepage;
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/Jeinzi/thunar-dropbox";
    description = "A plugin that adds context-menu items for Dropbox to Thunar";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
