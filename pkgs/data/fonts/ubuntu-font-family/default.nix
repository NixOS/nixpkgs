{ lib, fetchzip }:

fetchzip rec {
  name = "ubuntu-font-family-0.83";

  url = "https://assets.ubuntu.com/v1/fad7939b-ubuntu-font-family-0.83.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/ubuntu
  '';

  sha256 = "090y665h4kf2bi623532l6wiwkwnpd0xds0jr7560xwfwys1hiqh";

  meta = {
    description = "Ubuntu Font Family";
    longDescription = "The Ubuntu typeface has been specially
    created to complement the Ubuntu tone of voice. It has a
    contemporary style and contains characteristics unique to
    the Ubuntu brand that convey a precise, reliable and free attitude.";
    homepage = http://font.ubuntu.com/;
    license = lib.licenses.free;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.antono ];
  };
}
