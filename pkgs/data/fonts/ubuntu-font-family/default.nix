{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "ubuntu-font-family";
  version = "0.83";

  src = fetchzip {
    url = "https://assets.ubuntu.com/v1/fad7939b-ubuntu-font-family-0.83.zip";
    sha256 = "18w84svvk4d2z0w671l7r2j8j4rl1f0d0lr2xw0z6yq5mg87yxvg";
    stripRoot = false;
  };

  meta = {
    description = "Ubuntu Font Family";
    longDescription = "The Ubuntu typeface has been specially
    created to complement the Ubuntu tone of voice. It has a
    contemporary style and contains characteristics unique to
    the Ubuntu brand that convey a precise, reliable and free attitude.";
    homepage = "https://font.ubuntu.com/";
    license = lib.licenses.free;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.antono ];
  };
}
