{ lib, fetchzip, mkFont }:

mkFont rec {
  pname = "vdrsymbols";
  version = "20100612";

  src = fetchzip {
    url = "http://andreas.vdr-developer.org/fonts/download/vdrsymbols-ttf-20100612.tgz";
    sha256 = "0yjprvwdfb0wr22qjb3m449fbksa67i9drbwrzmx5k6hwb6yx1bi";
  };

  meta = with lib; {
    description = "DejaVu fonts with additional symbols used by VDR";
    homepage = "http://andreas.vdr-developer.org/fonts/";
    platforms = platforms.all;
    maintainers = with maintainers; [ ck3d ];

    # Copyright (c) 2003 by Bitstream, Inc. All Rights Reserved.
    # Copyright (c) 2006 by Tavmjong Bah. All Rights Reserved.
    # DejaVu changes are in public domain
    # See https://dejavu-fonts.github.io/License.html for details
    license = licenses.free;
  };
}
