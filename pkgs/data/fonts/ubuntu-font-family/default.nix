{ lib, fetchzip }:

fetchzip rec {
  pname = "ubuntu-font-family";
  version = "0.83";

  url = "https://assets.ubuntu.com/v1/fad7939b-ubuntu-font-family-${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/ubuntu
    mv $out/*.ttf $out/share/fonts/ubuntu
    find $out -maxdepth 1 ! -type d -exec rm {} +
  '';

  sha256 = "090y665h4kf2bi623532l6wiwkwnpd0xds0jr7560xwfwys1hiqh";

  meta = with lib; {
    description = "Ubuntu Font Family";
    longDescription = "The Ubuntu typeface has been specially
    created to complement the Ubuntu tone of voice. It has a
    contemporary style and contains characteristics unique to
    the Ubuntu brand that convey a precise, reliable and free attitude.";
    homepage = "http://font.ubuntu.com/";
    license = licenses.free;
    platforms = platforms.all;
    maintainers = [ maintainers.antono ];
  };
}
