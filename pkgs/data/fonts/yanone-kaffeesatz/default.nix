{ lib, fetchzip }:

fetchzip {
  name = "yanone-kaffeesatz-2004";

  url = https://yanone.de/2015/data/UIdownloads/Yanone%20Kaffeesatz.zip;

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
  '';

  sha256 = "190c4wx7avy3kp98lsyml7kc0jw7csf5n79af2ypbkhsadfsy8di";

  meta = {
    description = "The free font classic";
    maintainers = with lib.maintainers; [ mt-caret ];
    platforms = with lib.platforms; all;
    homepage = https://yanone.de/fonts/kaffeesatz/;
    license = lib.licenses.ofl;
  };
}
