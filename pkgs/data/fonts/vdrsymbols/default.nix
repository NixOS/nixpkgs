{ lib, fetchzip }:

fetchzip rec {
  name = "vdrsymbols-20100612";

  url = http://andreas.vdr-developer.org/fonts/download/vdrsymbols-ttf-20100612.tgz;

  sha256 = "0wpxns8zqic98c84j18dr4zmj092v07yq07vwwgzblr0rw9n6gzr";

  postFetch = ''
    tar xvzf "$downloadedFile"
    install -Dm444 -t "$out/share/fonts/truetype" */*.ttf
  '';

  meta = with lib; {
    description = "DejaVu fonts with additional symbols used by VDR";
    homepage = http://andreas.vdr-developer.org/fonts/;
    platforms = platforms.all;
    maintainers = with maintainers; [ ck3d ];

    # Copyright (c) 2003 by Bitstream, Inc. All Rights Reserved.
    # Copyright (c) 2006 by Tavmjong Bah. All Rights Reserved.
    # DejaVu changes are in public domain
    # See https://dejavu-fonts.github.io/License.html for details
    license = licenses.free;
  };
}
