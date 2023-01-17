# when changing this expression convert it from 'fetchzip' to 'stdenvNoCC.mkDerivation'
{ lib, fetchzip }:

let
  version = "1.0.2";
in (fetchzip {
  name = "andagii-${version}";

  url = "http://www.i18nguy.com/unicode/andagii.zip";
  curlOpts = "--user-agent 'Mozilla/5.0'";
  sha256 = "0j5kf2fmyqgnf5ji6h0h79lq9n9d85hkfrr4ya8hqj4gwvc0smb2";

  # There are multiple claims that the font is GPL, so I include the
  # package; but I cannot find the original source, so use it on your
  # own risk Debian claims it is GPL - good enough for me.
  meta = with lib; {
    homepage = "http://www.i18nguy.com/unicode/unicode-font.html";
    description = "Unicode Plane 1 Osmanya script font";
    maintainers = with maintainers; [ raskin ];
    license = "unknown";
    platforms = platforms.all;
  };
}).overrideAttrs (_: {
  postFetch = ''
    unzip $downloadedFile
    mkdir -p $out/share/fonts/truetype
    cp -v ANDAGII_.TTF $out/share/fonts/truetype/andagii.ttf
  '';
})
