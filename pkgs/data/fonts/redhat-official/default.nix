{ lib, fetchzip }:

let version = "2.2.0"; in
fetchzip {
  name = "redhat-official-${version}";
  url = "https://github.com/RedHatOfficial/RedHatFont/archive/${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/opentype
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
  '';

  sha256 = "0yb6shgq6jrv3kq9faky66qpdbv4g580c3jl942844grwyngymyj";

  meta = with lib; {
    homepage = https://github.com/RedHatOfficial/RedHatFont;
    description = "Red Hat's Open Source Fonts - Red Hat Display and Red Hat Text";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ dtzWill ];
  };
}
