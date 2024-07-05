{ stdenv
, lib
, fetchFromGitHub
, dde-api
}:

stdenv.mkDerivation rec {
  pname = "deepin-wallpapers";
  version = "1.7.16";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-o5rg1l8N6Ch+BdBLp+HMbVBBvrTdRtn8NSgH/9AnB2Q=";
  };

  nativeBuildInputs = [ dde-api ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace /usr/lib/deepin-api/image-blur ${dde-api}/lib/deepin-api/image-blur
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/wallpapers/deepin
    cp deepin/* $out/share/wallpapers/deepin
    mkdir -p $out/share/wallpapers/image-blur
    cp image-blur/* $out/share/wallpapers/image-blur
    mkdir -p $out/share/backgrounds
    ln -s $out/share/wallpapers/deepin/desktop.jpg  $out/share/backgrounds/default_background.jpg
    runHook postInstall
  '';

  meta = with lib; {
    description = "deepin-wallpapers provides wallpapers of dde";
    homepage = "https://github.com/linuxdeepin/deepin-wallpapers";
    license = with licenses; [ gpl3Plus cc-by-sa-30 ];
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
