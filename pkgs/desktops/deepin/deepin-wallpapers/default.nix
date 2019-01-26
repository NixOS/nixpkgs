{ stdenv, fetchFromGitHub, dde-api, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "deepin-wallpapers";
  version = "1.7.5";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "deepin-wallpapers";
    rev = version;
    sha256 = "0mfjkh81ci0gjwmgycrh32by7v9b73nyvyjbqd29ccpb8bpyyakn";
  };

  nativeBuildInputs = [ dde-api.bin ];

  postPatch = ''
    sed -i -e "s:/usr/lib/deepin-api:${dde-api.bin}/lib/deepin-api:" Makefile
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
