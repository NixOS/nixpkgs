{ stdenv, fetchFromGitHub, dde-api, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "deepin-wallpapers";
  version = "1.7.7";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "deepin-wallpapers";
    rev = version;
    sha256 = "09cfnxbpms98ibqbi4xd51181q3az5n8rmndcdr9w12kyzniz7xv";
  };

  nativeBuildInputs = [ dde-api deepin.setupHook ];

  postPatch = ''
    searchHardCodedPaths # debugging

    sed -i -e "s:/usr/lib/deepin-api:${dde-api}/lib/deepin-api:" Makefile
    sed -i -e "s:/usr/share/wallpapers:$out/share/wallpapers:" Makefile
  '';

  installPhase = ''
    mkdir -p $out/share/wallpapers/deepin
    cp -a deepin/* deepin-community/* deepin-private/* $out/share/wallpapers/deepin
    mkdir -p $out/var/cache
    cp -a image-blur $out/var/cache
    
    # Suggested by upstream
    mkdir -p $out/share/backgrounds/deepin
    ln -s ../../wallpapers/deepin/Hummingbird_by_Shu_Le.jpg $out/share/backgrounds/deepin/desktop.jpg
    ln -s $(echo -n $out/share/wallpapers/deepin/Hummingbird_by_Shu_Le.jpg | md5sum | cut -d " " -f 1).jpg \
      $out/var/cache/image-blur/$(echo -n $out/share/backgrounds/deepin/desktop.jpg | md5sum | cut -d " " -f 1).jpg
  '';

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "Wallpapers for Deepin Desktop Environment";
    homepage = https://github.com/linuxdeepin/deepin-wallpapers;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
