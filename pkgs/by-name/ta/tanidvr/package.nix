{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "tanidvr";
  version = "1.4.1";

  src = fetchurl {
    url = "mirror://sourceforge/tanidvr/TaniDVR/${pname}-${version}/${pname}-${version}.tar.bz2";
    sha256 = "0irwwf6mb72n3y4xcrl3s081nbnldvdlc6ypjqxa4p32c1d0g6ql";
  };

  meta = {
    description = "CLI tool for managing and capturing video from DVRs which use the DVR-IP protocol";
    homepage = "https://tanidvr.sourceforge.net/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ pho ];
    platforms = lib.platforms.linux;
  };
}
