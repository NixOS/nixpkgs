# when changing this expression convert it from 'fetchzip' to 'stdenvNoCC.mkDerivation'
{ lib, fetchzip }:

let
  version = "1.3";
in (fetchzip {
  name = "mononoki-${version}";

  url = "https://github.com/madmalik/mononoki/releases/download/${version}/mononoki.zip";

  sha256 = "sha256-K2uOpJRmQ1NcDZfh6rorCF0MvGHFCsSW8J7Ue9OC/OY=";

  meta = with lib; {
    homepage = "https://github.com/madmalik/mononoki";
    description = "A font for programming and code review";
    license = licenses.ofl;
    platforms = platforms.all;
  };
}).overrideAttrs (_: {
  postFetch = ''
    mkdir -p $out/share/fonts/mononoki
    unzip -j $downloadedFile -d $out/share/fonts/mononoki
  '';
})
